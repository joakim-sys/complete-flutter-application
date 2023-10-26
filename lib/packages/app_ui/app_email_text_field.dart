import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/app_text_field.dart';

class AppEmailTextField extends StatelessWidget {
  const AppEmailTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffix,
    this.readOnly,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.emailAddress,
      autoFillHints: const [AutofillHints.email],
      autoCorrect: false,
      prefix: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.sm),
          child: Icon(Icons.email_outlined,
              color: AppColors.mediumEmphasisSurface, size: 24)),
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      suffix: suffix,
    );
  }
}
