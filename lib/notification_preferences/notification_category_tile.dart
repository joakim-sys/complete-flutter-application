import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class NotificationCategoryTile extends StatelessWidget {
  const NotificationCategoryTile(
      {super.key, required this.title, required this.trailing, this.onTap});

  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      trailing: trailing,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      horizontalTitleGap: 0,
      onTap: onTap,
      title: Text(
        toBeginningOfSentenceCase(title) ?? '',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
