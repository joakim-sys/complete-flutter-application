import 'package:flutter/material.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/packages/app_ui/app_button.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_font_weight.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class UserProfileSubscribeBox extends StatelessWidget {
  const UserProfileSubscribeBox({super.key, required this.onSubscribePressed});

  final VoidCallback onSubscribePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n!;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.userProfileSubscribeBoxSubtitle,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: AppFontWeight.medium),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.userProfileSubscribeBoxMessage,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.mediumEmphasisSurface),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.smallRedWine(
            onPressed: onSubscribePressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(l10n.userProfileSubscribeNowButtonText)],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
