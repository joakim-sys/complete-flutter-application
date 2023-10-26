import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_one/app_bloc_observer.dart';
import 'package:pro_one/packages/analytics_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

typedef AppBuilder = Future<Widget> Function(
    FirebaseDynamicLinks firebaseDynamicLinks,
    FirebaseMessaging firebaseMessaging,
    SharedPreferences sharedPreferences,
    AnalyticsRepository analyticsRepository);

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final analyticsRepository = AnalyticsRepository(FirebaseAnalytics.instance);
  final blocObserver =
      AppBlocObserver(analyticsRepository: analyticsRepository);
  Bloc.observer = blocObserver;
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationSupportDirectory());

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  final sharedPreferences = await SharedPreferences.getInstance();

  await runZonedGuarded(
    () async {
      unawaited(MobileAds.instance.initialize());
      runApp(await builder(FirebaseDynamicLinks.instance,
          FirebaseMessaging.instance, sharedPreferences, analyticsRepository));
    },
    FirebaseCrashlytics.instance.recordError,
  );
}
