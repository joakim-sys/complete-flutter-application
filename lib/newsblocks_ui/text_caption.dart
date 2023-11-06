import 'package:api/client.dart';
import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class TextCaption extends StatelessWidget {
  const TextCaption(
      {super.key, required this.block, this.colorValues = _defaultColorValues});

  final TextCaptionBlock block;
  final Map<TextCaptionColor, Color> colorValues;

  static const _defaultColorValues = <TextCaptionColor, Color>{
    TextCaptionColor.normal: AppColors.highEmphasisSurface,
    TextCaptionColor.light: AppColors.mediumEmphasisPrimary
  };

  @override
  Widget build(BuildContext context) {
    final color = colorValues.containsKey(block.color)
        ? colorValues[block.color]
        : AppColors.highEmphasisSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        block.text,
        style: Theme.of(context).textTheme.bodySmall?.apply(color: color),
      ),
    );
  }
}
