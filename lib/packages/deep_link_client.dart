import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:rxdart/rxdart.dart';

class DeepLinkClientFailure with EquatableMixin implements Exception {
  DeepLinkClientFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

class DeepLinkClient {
  DeepLinkClient({FirebaseDynamicLinks? firebaseDynamicLinks})
      : _deepLinkSubject = BehaviorSubject<Uri>() {
    _firebaseDynamicLinks =
        firebaseDynamicLinks ?? FirebaseDynamicLinks.instance;

    unawaited(_getInitialLink());
    _firebaseDynamicLinks.onLink.listen(_onAppLink).onError(_handleError);
  }

  late final FirebaseDynamicLinks _firebaseDynamicLinks;
  final BehaviorSubject<Uri> _deepLinkSubject;

  Stream<Uri> get deepLinkStream => _deepLinkSubject;

  Future<void> _getInitialLink() async {
    try {
      final deepLink = await _firebaseDynamicLinks.getInitialLink();
      if (deepLink != null) {
        _onAppLink(deepLink);
      }
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  void _onAppLink(PendingDynamicLinkData dynamicLinkData) {
    _deepLinkSubject.add(dynamicLinkData.link);
  }

  void _handleError(Object error, StackTrace stackTrace) {
    _deepLinkSubject.addError(DeepLinkClientFailure(error), stackTrace);
  }
}
