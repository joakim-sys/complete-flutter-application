import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/onboarding/onboarding_bloc.dart';
import 'package:pro_one/packages/ads_consent_client.dart';
import 'package:pro_one/packages/notifications_repository.dart';

import 'onboarding_view.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: OnboardingPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001F28),
      body: BlocProvider(
        create: (_) => OnboardingBloc(
          notificationsRepository: context.read<NotificationsRepository>(),
          adsConsentClient: context.read<AdsConsentClient>(),
        ),
        child: const OnboardingView(),
      ),
    );
  }
}
