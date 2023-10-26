import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class OnboardingViewItem extends StatelessWidget {
  const OnboardingViewItem({
    super.key,
    required this.pageNumberTitle,
    required this.title,
    required this.subtitle,
    required this.primaryButton,
    required this.secondaryButton,
  });

  final String pageNumberTitle;
  final String title;
  final String subtitle;
  final Widget primaryButton;
  final Widget secondaryButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xxlg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xlg + AppSpacing.sm,
            horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: AppColors.white),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Text(
                    pageNumberTitle,
                    style: theme.textTheme.labelSmall
                        ?.apply(color: AppColors.secondary.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg + AppSpacing.sm),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium
                        ?.apply(color: AppColors.highEmphasisSurface),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    subtitle,
                    style: theme.textTheme.titleMedium
                        ?.apply(color: AppColors.mediumEmphasisSurface),
                  ),
                  const Spacer(),
                  primaryButton,
                  const SizedBox(height: AppSpacing.sm),
                  secondaryButton,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
