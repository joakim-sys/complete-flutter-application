import 'package:flutter/material.dart';
import 'package:pro_one/newsblocks_ui/newsletter_container.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

import '../packages/app_ui/app_colors.dart';

class NewsletterSucceeded extends StatelessWidget {
  const NewsletterSucceeded(
      {super.key,
      required this.headerText,
      required this.content,
      required this.footerText});

  final String headerText;
  final Widget content;
  final String footerText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NewsletterContainer(
      child: Column(
        children: [
          Text(
            headerText,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium
                ?.copyWith(color: AppColors.highEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          content,
          SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          Text(
            footerText,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.mediumHighEmphasisPrimary),
          )
        ],
      ),
    );
  }
}
