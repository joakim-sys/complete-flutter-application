import 'dart:async';
import 'authentication_client.dart';
import 'package:equatable/equatable.dart';
import 'package:api/client.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class InAppPurchaseFailure with EquatableMixin implements Exception {
  const InAppPurchaseFailure(this.error);
  final Object error;

  @override
  List<Object> get props => [error];
}

class DeliverInAppPurchaseFailure extends InAppPurchaseFailure {
  const DeliverInAppPurchaseFailure(super.error);
}

class CompleteInAppPurchaseFailure extends InAppPurchaseFailure {
  const CompleteInAppPurchaseFailure(super.error);
}

class InternalInAppPurchaseFailure extends InAppPurchaseFailure {
  const InternalInAppPurchaseFailure(super.error);
}

class FetchSubscriptionsFailure extends InAppPurchaseFailure {
  const FetchSubscriptionsFailure(super.error);
}

class QueryInAppProductDetailsFailure extends InAppPurchaseFailure {
  const QueryInAppProductDetailsFailure(super.error);
}

class InAppPurchaseBuyNonConsumableFailure extends InAppPurchaseFailure {
  const InAppPurchaseBuyNonConsumableFailure(super.error);
}

class InAppPurchaseRepository {
  InAppPurchaseRepository({
    required AuthenticationClient authenticationClient,
    required TrcApiClient apiClient,
    required InAppPurchase inAppPurchase,
  })  : _apiClient = apiClient,
        _authenticationClient = authenticationClient,
        _inAppPurchase = inAppPurchase {
    _inAppPurchase.purchaseStream
        .expand((value) => value)
        .listen(_onPurchaseUpdated);
  }

  final InAppPurchase _inAppPurchase;
  final TrcApiClient _apiClient;
  final AuthenticationClient _authenticationClient;

  final _purchaseUpdateStreamController =
      StreamController<PurchaseUpdate>.broadcast();

  Stream<PurchaseUpdate> get purchaseUpdate =>
      _purchaseUpdateStreamController.stream.asBroadcastStream();

  List<Subscription>? _cachedSubscriptions;

  Future<List<Subscription>> fetchSubscriptions() async {
    try {
      if (_cachedSubscriptions != null) {
        return _cachedSubscriptions!;
      }
      final response = await _apiClient.getSubscriptions();
      _cachedSubscriptions = response.subscriptions;
      return _cachedSubscriptions ?? [];
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchSubscriptionsFailure(error),
        stackTrace,
      );
    }
  }

  Future<void> purchase({
    required Subscription subscription,
  }) async {
    final productDetailsResponse =
        await _inAppPurchase.queryProductDetails({subscription.id});

    if (productDetailsResponse.error != null) {
      Error.throwWithStackTrace(
        QueryInAppProductDetailsFailure(
          productDetailsResponse.error.toString(),
        ),
        StackTrace.current,
      );
    }

    if (productDetailsResponse.productDetails.isEmpty) {
      Error.throwWithStackTrace(
        QueryInAppProductDetailsFailure(
          'No subscription found with id ${subscription.id}.',
        ),
        StackTrace.current,
      );
    }

    if (productDetailsResponse.productDetails.length > 1) {
      Error.throwWithStackTrace(
        QueryInAppProductDetailsFailure(
          'Found ${productDetailsResponse.productDetails.length} products '
          'with id ${subscription.id}. Only one should be found.',
        ),
        StackTrace.current,
      );
    }

    final productDetails = productDetailsResponse.productDetails.first;

    final user = await _authenticationClient.user.first;

    final purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: user.id,
    );

    final isPurchaseRequestSuccessful =
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

    if (!isPurchaseRequestSuccessful) {
      Error.throwWithStackTrace(
        InAppPurchaseBuyNonConsumableFailure(
          'Failed to buy ${productDetails.id} for user ${user.id}',
        ),
        StackTrace.current,
      );
    }
  }

  Future<void> restorePurchases() async {
    final user = await _authenticationClient.user.first;
    if (!user.isAnonymous) {
      await _inAppPurchase.restorePurchases(applicationUserName: user.id);
    }
  }

  Future<void> _onPurchaseUpdated(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.canceled) {
      _purchaseUpdateStreamController.add(const PurchaseCanceled());
    }

    if (purchase.status == PurchaseStatus.error) {
      _purchaseUpdateStreamController.add(
        PurchaseFailed(
          failure: InternalInAppPurchaseFailure(
            purchase.error.toString(),
          ),
        ),
      );
    }

    try {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final purchasedProduct = (await fetchSubscriptions())
            .firstWhere((product) => product.id == purchase.productID);

        _purchaseUpdateStreamController.add(
          PurchasePurchased(subscription: purchasedProduct),
        );

        await _apiClient.createSubscription(
          subscriptionId: purchasedProduct.id,
        );

        _purchaseUpdateStreamController.add(
          PurchaseDelivered(subscription: purchasedProduct),
        );
      }
    } catch (error, stackTrace) {
      _purchaseUpdateStreamController.addError(
        PurchaseFailed(
          failure: DeliverInAppPurchaseFailure(
            error,
          ),
        ),
        stackTrace,
      );
    }

    try {
      if (purchase.pendingCompletePurchase) {
        final purchasedSubscription = (await fetchSubscriptions()).firstWhere(
          (subscription) => subscription.id == purchase.productID,
        );

        await _inAppPurchase.completePurchase(purchase);

        _purchaseUpdateStreamController.add(
          PurchaseCompleted(
            subscription: purchasedSubscription,
          ),
        );
      }
    } catch (error, stackTrace) {
      _purchaseUpdateStreamController.addError(
        PurchaseFailed(
          failure: CompleteInAppPurchaseFailure(
            error,
          ),
        ),
        stackTrace,
      );
    }
  }
}

abstract class PurchaseUpdate extends Equatable {
  const PurchaseUpdate();
}

class PurchaseDelivered extends PurchaseUpdate {
  const PurchaseDelivered({
    required this.subscription,
  }) : super();

  final Subscription subscription;

  @override
  List<Object> get props => [subscription];
}

class PurchaseCompleted extends PurchaseUpdate {
  const PurchaseCompleted({
    required this.subscription,
  }) : super();

  final Subscription subscription;

  @override
  List<Object> get props => [subscription];
}

class PurchasePurchased extends PurchaseUpdate {
  const PurchasePurchased({
    required this.subscription,
  }) : super();

  final Subscription subscription;

  @override
  List<Object> get props => [subscription];
}

class PurchaseCanceled extends PurchaseUpdate {
  const PurchaseCanceled() : super();

  @override
  List<Object> get props => [];
}

class PurchaseFailed extends PurchaseUpdate {
  const PurchaseFailed({
    required this.failure,
  }) : super();

  final InAppPurchaseFailure failure;

  @override
  List<Object> get props => [];
}
