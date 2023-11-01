import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_theme.dart';

class ContentThemeOverrideBuilder extends StatelessWidget {
  const ContentThemeOverrideBuilder({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
        data: theme.copyWith(textTheme: AppTheme.contentTextTheme),
        child: Builder(builder: builder));
  }
}
