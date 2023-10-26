import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/platform.dart';
import 'package:pro_one/ads/ads_retry_policy.dart';
import 'package:pro_one/ads/full_screen_ads_bloc.dart';
import 'package:pro_one/analytics/analytics_bloc.dart';
import 'package:pro_one/app/authenticated_user_listener.dart';
import 'package:pro_one/app/routes.dart';
import 'package:pro_one/login/login_with_email_link_bloc.dart';
import 'package:pro_one/packages/ads_consent_client.dart';
import 'package:pro_one/packages/analytics_repository.dart';
import 'package:pro_one/packages/app_ui/app_theme.dart';
import 'package:pro_one/packages/article_repository.dart';
import 'package:pro_one/packages/in_app_purchase_repository.dart';
import 'package:pro_one/packages/news_repository.dart';
import 'package:pro_one/packages/notifications_repository.dart';
import 'package:pro_one/packages/user_repository.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pro_one/theme_selector/theme_mode_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;

class App extends StatelessWidget {
  const App({
    super.key,
    required UserRepository userRepository,
    required NewsRepository newsRepository,
    required NotificationsRepository notificationsRepository,
    required ArticleRepository articleRepository,
    required InAppPurchaseRepository inAppPurchaseRepository,
    required AnalyticsRepository analyticsRepository,
    required AdsConsentClient adsConsentClient,
    required User user,
  })  : _userRepository = userRepository,
        _newsRepository = newsRepository,
        _notificationsRepository = notificationsRepository,
        _articleRepository = articleRepository,
        _inAppPurchaseRepository = inAppPurchaseRepository,
        _analyticsRepository = analyticsRepository,
        _adsConsentClient = adsConsentClient,
        _user = user;

  final UserRepository _userRepository;
  final NewsRepository _newsRepository;
  final NotificationsRepository _notificationsRepository;
  final ArticleRepository _articleRepository;
  final InAppPurchaseRepository _inAppPurchaseRepository;
  final AnalyticsRepository _analyticsRepository;
  final AdsConsentClient _adsConsentClient;
  final User _user;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _newsRepository),
        RepositoryProvider.value(value: _notificationsRepository),
        RepositoryProvider.value(value: _articleRepository),
        RepositoryProvider.value(value: _analyticsRepository),
        RepositoryProvider.value(value: _inAppPurchaseRepository),
        RepositoryProvider.value(value: _adsConsentClient),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
                userRepository: _userRepository,
                notificationsRepository: _notificationsRepository,
                user: _user),
          ),
          BlocProvider(
              create: (context) => AnalyticsBloc(
                  analyticsRepository: _analyticsRepository,
                  userRepository: _userRepository),
              lazy: false),
          BlocProvider(create: (_) => ThemeModeBloc()),
          BlocProvider(
              create: (_) =>
                  LoginWithEmailLinkBloc(userRepository: _userRepository),
              lazy: false),
          BlocProvider(
              create: (context) => FullScreenAdsBloc(
                  adsRetryPolicy: const AdsRetryPolicy(),
                  interstitialAdLoader: ads.InterstitialAd.load,
                  rewardedAdLoader: ads.RewardedAd.load,
                  localPlatform: const LocalPlatform())
                ..add(const LoadInterstitialAdRequested())
                ..add(const LoadRewardedAdRequested()),
              lazy: false)
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: const AppTheme().themeData,
      darkTheme: const AppDarkTheme().themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: AuthenticatedUserListener(
          child: FlowBuilder<AppStatus>(
        onGeneratePages: onGenerateAppViewPages,
        state: context.select((AppBloc bloc) => bloc.state.status),
      )),
    );
  }
}
