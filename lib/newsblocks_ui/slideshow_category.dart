import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';

import '../packages/app_ui/app_spacing.dart';

class SlideshowCategory extends StatelessWidget {
  const SlideshowCategory(
      {super.key, required this.slideshowText, this.isIntroduction = true});

  final bool isIntroduction;
  final String slideshowText;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isIntroduction ? AppColors.secondary : AppColors.transparent;
    final textColor = isIntroduction ? AppColors.white : AppColors.orange;
    const horizontalSpacing = AppSpacing.xs;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  horizontalSpacing, 0, horizontalSpacing, AppSpacing.xxs),
              child: Text(
                slideshowText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: textColor),
              ),
            ),
          ),
        )
      ],
    );
  }
}
