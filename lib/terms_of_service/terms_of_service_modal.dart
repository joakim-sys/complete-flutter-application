import 'package:flutter/material.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/terms_of_service/terms_of_service_body.dart';

class TermsOfServiceModal extends StatelessWidget {
  const TermsOfServiceModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
      heightFactor: 0.9,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TermsOfServiceModalHeader(),
              TermsOfServiceBody(
                contentPadding:
                    EdgeInsets.only(right: AppSpacing.xlg + AppSpacing.sm),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TermsOfServiceModalHeader extends StatelessWidget {
  const TermsOfServiceModalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Text(context.l10n!.termsOfServiceModalTitle,
                style: theme.textTheme.displaySmall),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 24, height: 36),
          )
        ],
      ),
    );
  }
}
