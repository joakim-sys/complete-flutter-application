import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/content_theme_override_builder.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch(
      {super.key,
      required this.value,
      required this.onChanged,
      this.onText = '',
      this.offText = ''});

  final String onText;
  final String offText;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ContentThemeOverrideBuilder(
            builder: ((context) => Text(
                  value ? onText : offText,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.eerieBlack),
                ))),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xxs),
          child: Switch(value: value, onChanged: onChanged),
        )
      ],
    );
  }
}
