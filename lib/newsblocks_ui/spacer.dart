import 'package:api/client.dart';
import 'package:flutter/material.dart';

class Spacer extends StatelessWidget {
  const Spacer({super.key, required this.block});

  final SpacerBlock block;

  static const _spacingValues = <Spacing, double>{
    Spacing.extraSmall: 4,
    Spacing.small: 8,
    Spacing.medium: 16,
    Spacing.large: 32,
    Spacing.veryLarge: 48,
    Spacing.extraLarge: 64
  };

  @override
  Widget build(BuildContext context) {
    final spacing = _spacingValues.containsKey(block.spacing)
        ? _spacingValues[block.spacing]
        : 0.0;
    return SizedBox(
      width: double.infinity,
      height: spacing,
    );
  }
}
