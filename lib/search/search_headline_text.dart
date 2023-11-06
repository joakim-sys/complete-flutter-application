import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class SearchHeadlineText extends StatelessWidget {
  const SearchHeadlineText({super.key, required this.headerText});

  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
      child: Text(
        headerText.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: AppColors.secondary),
      ),
    );
  }
}
