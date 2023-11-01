import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';

class ShareButton extends StatelessWidget {
  const ShareButton(
      {super.key, required this.shareText, this.onPressed, Color? color})
      : _color = color ?? AppColors.black;

  final String shareText;
  final VoidCallback? onPressed;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.share,
          color: _color,
        ),
        label: Text(
          shareText,
          style: theme.textTheme.labelLarge?.copyWith(color: _color),
        ));
  }
}
