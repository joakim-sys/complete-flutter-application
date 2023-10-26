import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class PostContentCategory extends StatelessWidget {
  const PostContentCategory(
      {super.key,
      required this.categoryName,
      required this.isContentOverlaid,
      required this.isVideoContent});

  final String categoryName;
  final bool isContentOverlaid;
  final bool isVideoContent;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isContentOverlaid ? AppColors.secondary : AppColors.transparent;
    final isCategoryBackgroundDark = isContentOverlaid;
    final textColor = isVideoContent
        ? AppColors.orange
        : isCategoryBackgroundDark
            ? AppColors.white
            : AppColors.secondary;

    final horizontalSpacing = isCategoryBackgroundDark ? AppSpacing.xs : 0.0;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  horizontalSpacing, 0, horizontalSpacing, AppSpacing.xxs),
              child: Text(
                categoryName.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: textColor),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm)
      ],
    );
  }
}
