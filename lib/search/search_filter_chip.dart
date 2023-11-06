import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class SearchFilterChip extends StatelessWidget {
  const SearchFilterChip(
      {super.key, required this.onSelected, required this.chipText});

  final ValueSetter<String> onSelected;
  final String chipText;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(chipText, style: Theme.of(context).textTheme.labelLarge),
      onSelected: (_) => onSelected(chipText),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borderOutline),
          borderRadius: BorderRadius.circular(AppSpacing.sm)),
    );
  }
}
