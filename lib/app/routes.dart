import 'package:flutter/widgets.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/home/home_page.dart';
import 'package:pro_one/onboarding/onboarding_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.onboardingRequired:
      return [OnboardingPage.page()];
    case AppStatus.unauthenticated:
    case AppStatus.authenticated:
      return [HomePage.page()];
      // return [OnboardingPage.page()];
  }
}
