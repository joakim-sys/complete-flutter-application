import 'package:flutter/material.dart';
import 'package:pro_one/newsblocks_ui/newsletter_container.dart';
import 'package:pro_one/packages/app_ui/app_button.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class NewsletterSignUp extends StatelessWidget {
  const NewsletterSignUp(
      {super.key,
      required this.headerText,
      required this.bodyText,
      required this.email,
      required this.buttonText,
      required this.onPressed});

  final String headerText;
  final String bodyText;
  final Widget email;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NewsletterContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            headerText,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium
                ?.copyWith(color: AppColors.highEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            bodyText,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: AppColors.mediumEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          email,
          AppButton.secondary(
              onPressed: onPressed,
              textStyle:
                  theme.textTheme.labelLarge?.copyWith(color: AppColors.white),
              child: Text(buttonText))
        ],
      ),
    );
  }
}
