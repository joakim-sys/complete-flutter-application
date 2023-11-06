import 'package:api/client.dart';
import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class TextLeadParagraph extends StatelessWidget {
  const TextLeadParagraph({super.key, required this.block});

  final TextLeadParagraphBlock block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        block.text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
