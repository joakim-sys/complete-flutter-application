import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';

class ShareFailure with EquatableMixin implements Exception {
  const ShareFailure(this.error);
  final Object error;

  @override
  List<Object?> get props => [error];
}

typedef ShareProvider = Future<void> Function(String);

class ShareLauncher {
  const ShareLauncher({ShareProvider? shareProvider})
      : _shareProvider = shareProvider ?? Share.share;

  final ShareProvider _shareProvider;

  Future<void> share({required String text}) async {
    try {
      return _shareProvider(text);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ShareFailure(error), stackTrace);
    }
  }
}
