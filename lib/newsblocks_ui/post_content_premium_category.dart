import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class PostContentPremiumCategory extends StatelessWidget {
  const PostContentPremiumCategory(
      {super.key, required this.premiumText, required this.isVideoContent});

  final String premiumText;
  final bool isVideoContent;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.redWine;
    const textColor = AppColors.white;
    const horizontalSpacing = AppSpacing.xs;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: const BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  horizontalSpacing, 0, horizontalSpacing, AppSpacing.xxs),
              child: Text(
                premiumText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: textColor),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
