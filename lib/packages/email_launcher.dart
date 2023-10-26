import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

abstract class EmailLauncherException implements Exception {
  const EmailLauncherException(this.error);
  final Object error;
}

class LaunchEmailAppFailure extends EmailLauncherException {
  const LaunchEmailAppFailure(super.error);
}

typedef LaunchUrlProvider = Future<bool> Function(Uri url);

typedef CanLaunchUrlProvider = Future<bool> Function(Uri url);

class EmailLauncher {
  EmailLauncher({
    LaunchUrlProvider? launchUrlProvider,
    CanLaunchUrlProvider? canLaunchUrlProvider,
  })  : _launchUrlProvider = launchUrlProvider ?? launchUrl,
        _canLaunchUrlProvider = canLaunchUrlProvider ?? canLaunchUrl;

  final LaunchUrlProvider _launchUrlProvider;
  final CanLaunchUrlProvider _canLaunchUrlProvider;

  Future<void> launchEmailApp() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        const intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.APP_EMAIL',
        );
        await intent.launch();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final url = Uri(scheme: 'message');
        if (await _canLaunchUrlProvider(url)) {
          await _launchUrlProvider(url);
        }
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LaunchEmailAppFailure(error), stackTrace);
    }
  }
}
