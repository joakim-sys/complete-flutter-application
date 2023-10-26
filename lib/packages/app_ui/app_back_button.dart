import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import 'app_colors.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    Key? key,
    VoidCallback? onPressed,
  }) : this._(
          key: key,
          isLight: false,
          onPressed: onPressed,
        );

  const AppBackButton.light({
    Key? key,
    VoidCallback? onPressed,
  }) : this._(
          key: key,
          isLight: true,
          onPressed: onPressed,
        );

  const AppBackButton._({required this.isLight, this.onPressed, super.key});

  final bool isLight;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Assets.icons.backIcon.svg(
        color: isLight ? AppColors.white : AppColors.highEmphasisSurface,
      ),
    );
  }
}
