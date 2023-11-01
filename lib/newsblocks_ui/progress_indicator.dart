import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator(
      {super.key, this.progress, this.color = AppColors.gainsboro});

  final double? progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: Center(
        child: CircularProgressIndicator(value: progress),
      ),
    );
  }
}
