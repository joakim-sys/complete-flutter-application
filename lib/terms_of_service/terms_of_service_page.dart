import 'package:flutter/material.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/packages/app_ui/app_back_button.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/terms_of_service/terms_of_service_body.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const TermsOfServicePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TermsOfServiceHeader(),
          TermsOfServiceBody(
            contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xlg, vertical: AppSpacing.lg),
          ),
          SizedBox(height: AppSpacing.lg)
        ],
      ),
    );
  }
}

class TermsOfServiceHeader extends StatelessWidget {
  const TermsOfServiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
      child: Text(
        context.l10n!.termsOfServiceModalTitle,
        style: theme.textTheme.headlineMedium,
      ),
    );
  }
}
