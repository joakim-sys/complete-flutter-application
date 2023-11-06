import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/app_text_field.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AppTextField(
        controller: controller,
        prefix: const Icon(Icons.search),
        suffix: IconButton(
            onPressed: controller.clear, icon: const Icon(Icons.clear)),
        hintText: context.l10n!.searchByKeyword,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
