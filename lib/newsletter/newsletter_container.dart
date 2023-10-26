import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class NewsletterContainer extends StatelessWidget {
  const NewsletterContainer({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ColoredBox(
        color: AppColors.secondary.shade800,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xlg + AppSpacing.sm),
          child: child,
        ),
      ),
    );
  }
}
