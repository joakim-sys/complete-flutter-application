import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/onboarding/onboarding_bloc.dart';
import 'package:pro_one/onboarding/onboarding_view_item.dart';
import 'package:pro_one/packages/app_ui/app_button.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController();
  static const _onboardingItemSwitchDuration = Duration(milliseconds: 500);
  static const _onboardingPageTwo = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if ((state is EnablingAdTrackingSucceeded ||
                state is EnablingAdTrackingFailed) &&
            _controller.page != _onboardingPageTwo) {
          _controller.animateToPage(_onboardingPageTwo,
              duration: _onboardingItemSwitchDuration, curve: Curves.easeInOut);
        } else if (state is EnablingNotificationsSucceeded) {
          context.read<AppBloc>().add(const AppOnboardingCompleted());
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _OnboardingTitle(),
                const _OnboardingSubtitle(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .59,
                  child: PageView(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      OnboardingViewItem(
                        pageNumberTitle:
                            context.l10n!.onboardingItemFirstNumberTitle,
                        title: context.l10n!.onboardingItemFirstTitle,
                        subtitle:
                            context.l10n!.onboardingItemFirstSubtitleTitle,
                        primaryButton: AppButton.darkAqua(
                          onPressed: () => context
                              .read<OnboardingBloc>()
                              .add(const EnableAdTrackingRequested()),
                          child: Text(
                              context.l10n!.onboardingItemFirstButtonTitle),
                        ),
                        secondaryButton: AppButton.smallTransparent(
                          onPressed: () => _controller.animateToPage(
                              _onboardingPageTwo,
                              duration: _onboardingItemSwitchDuration,
                              curve: Curves.easeInOut),
                          child: Text(
                              context.l10n!.onboardingItemSecondaryButtonTitle),
                        ),
                      ),
                      OnboardingViewItem(
                          pageNumberTitle:
                              context.l10n!.onboardingItemSecondNumberTitle,
                          title: context.l10n!.onboardingItemSecondTitle,
                          subtitle:
                              context.l10n!.onboardingItemSecondSubtitleTitle,
                          primaryButton: AppButton.darkAqua(
                              onPressed: () => context
                                  .read<OnboardingBloc>()
                                  .add(const EnableNotificationsRequested()),
                              child: Text(context
                                  .l10n!.onboardingItemSecondButtonTitle)),
                          secondaryButton: AppButton.smallTransparent(
                              onPressed: () => context
                                  .read<AppBloc>()
                                  .add(const AppOnboardingCompleted()),
                              child: Text(context
                                  .l10n!.onboardingItemSecondaryButtonTitle)))
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OnboardingTitle extends StatelessWidget {
  const _OnboardingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16 * 4 + 0.5 * 4, bottom: 16 * 0.125),
      child: Text(
        context.l10n!.onboardingWelcomeTitle,
        // 'Welcome to\nAlgorithm Alley',
        textAlign: TextAlign.center,
        style: theme.textTheme.displayLarge?.apply(color: Color(0xFFFFFFFF)),
      ),
    );
  }
}

class _OnboardingSubtitle extends StatelessWidget {
  const _OnboardingSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 16 * 1.5),
      child: Text(
        context.l10n!.onboardingSubtitle,
        style: theme.textTheme.titleMedium?.apply(color: Color(0xFFFFFFFF)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
