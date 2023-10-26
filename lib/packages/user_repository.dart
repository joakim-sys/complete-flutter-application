import 'package:equatable/equatable.dart';
import 'package:pro_one/packages/package_info_client.dart';
import 'package:pro_one/packages/storage.dart';
import 'package:rxdart/rxdart.dart';

import 'authentication_client.dart';
import 'package:api/client.dart';

import 'deep_link_client.dart';

class User extends AuthenticationUser {
  const User({
    required this.subscriptionPlan,
    required super.id,
    super.email,
    super.name,
    super.photo,
    super.isNewUser,
  });

  factory User.fromAuthenticationUser({
    required AuthenticationUser authenticationUser,
    required SubscriptionPlan subscriptionPlan,
  }) =>
      User(
        email: authenticationUser.email,
        id: authenticationUser.id,
        name: authenticationUser.name,
        photo: authenticationUser.photo,
        isNewUser: authenticationUser.isNewUser,
        subscriptionPlan: subscriptionPlan,
      );

  @override
  bool get isAnonymous => this == anonymous;

  static const User anonymous = User(
    id: '',
    subscriptionPlan: SubscriptionPlan.none,
  );

  final SubscriptionPlan subscriptionPlan;
}

abstract class UserStorageKeys {
  static const appOpenedCount = '__app_opened_count_key__';
}

class UserStorage {
  const UserStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  Future<void> setAppOpenedCount({required int count}) => _storage.write(
        key: UserStorageKeys.appOpenedCount,
        value: count.toString(),
      );

  Future<int> fetchAppOpenedCount() async {
    final count = await _storage.read(key: UserStorageKeys.appOpenedCount);
    return int.parse(count ?? '0');
  }
}

abstract class UserFailure with EquatableMixin implements Exception {
  const UserFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

class FetchAppOpenedCountFailure extends UserFailure {
  const FetchAppOpenedCountFailure(super.error);
}

class IncrementAppOpenedCountFailure extends UserFailure {
  const IncrementAppOpenedCountFailure(super.error);
}

class FetchCurrentSubscriptionFailure extends UserFailure {
  const FetchCurrentSubscriptionFailure(super.error);
}

class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required TrcApiClient apiClient,
    required AuthenticationClient authenticationClient,
    required PackageInfoClient packageInfoClient,
    required DeepLinkClient deepLinkClient,
    required UserStorage storage,
  })  : _apiClient = apiClient,
        _authenticationClient = authenticationClient,
        _packageInfoClient = packageInfoClient,
        _deepLinkClient = deepLinkClient,
        _storage = storage;

  final TrcApiClient _apiClient;
  final AuthenticationClient _authenticationClient;
  final PackageInfoClient _packageInfoClient;
  final DeepLinkClient _deepLinkClient;
  final UserStorage _storage;

  Stream<User> get user =>
      Rx.combineLatest2<AuthenticationUser, SubscriptionPlan, User>(
        _authenticationClient.user,
        _currentSubscriptionPlanSubject.stream,
        (authenticationUser, subscriptionPlan) => User.fromAuthenticationUser(
          authenticationUser: authenticationUser,
          subscriptionPlan: authenticationUser != AuthenticationUser.anonymous
              ? subscriptionPlan
              : SubscriptionPlan.none,
        ),
      ).asBroadcastStream();

  final BehaviorSubject<SubscriptionPlan> _currentSubscriptionPlanSubject =
      BehaviorSubject.seeded(SubscriptionPlan.none);

  Stream<Uri> get incomingEmailLinks => _deepLinkClient.deepLinkStream.where(
        (deepLink) => _authenticationClient.isLogInWithEmailLink(
          emailLink: deepLink.toString(),
        ),
      );

  Future<void> logInWithApple() async {
    try {
      await _authenticationClient.logInWithApple();
    } on LogInWithAppleFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithAppleFailure(error), stackTrace);
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      await _authenticationClient.logInWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  Future<void> logInWithTwitter() async {
    try {
      await _authenticationClient.logInWithTwitter();
    } on LogInWithTwitterFailure {
      rethrow;
    } on LogInWithTwitterCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithTwitterFailure(error), stackTrace);
    }
  }

  Future<void> logInWithFacebook() async {
    try {
      await _authenticationClient.logInWithFacebook();
    } on LogInWithFacebookFailure {
      rethrow;
    } on LogInWithFacebookCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithFacebookFailure(error), stackTrace);
    }
  }

  Future<void> sendLoginEmailLink({
    required String email,
  }) async {
    try {
      await _authenticationClient.sendLoginEmailLink(
        email: email,
        appPackageName: _packageInfoClient.packageName,
      );
    } on SendLoginEmailLinkFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SendLoginEmailLinkFailure(error), stackTrace);
    }
  }

  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    try {
      await _authenticationClient.logInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );
    } on LogInWithEmailLinkFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
    }
  }

  Future<void> logOut() async {
    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  Future<int> fetchAppOpenedCount() async {
    try {
      return await _storage.fetchAppOpenedCount();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchAppOpenedCountFailure(error),
        stackTrace,
      );
    }
  }

  Future<void> incrementAppOpenedCount() async {
    try {
      final value = await fetchAppOpenedCount();
      final result = value + 1;
      await _storage.setAppOpenedCount(count: result);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        IncrementAppOpenedCountFailure(error),
        stackTrace,
      );
    }
  }

  Future<void> updateSubscriptionPlan() async {
    try {
      final response = await _apiClient.getCurrentUser();
      _currentSubscriptionPlanSubject.add(response.user.subscription);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchCurrentSubscriptionFailure(error),
        stackTrace,
      );
    }
  }
}
