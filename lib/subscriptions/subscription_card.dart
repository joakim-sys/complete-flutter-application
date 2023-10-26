import 'package:api/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/gen/assets.gen.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/login/login_modal.dart';
import 'package:pro_one/packages/app_ui/app_button.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/show_app_modal.dart';
import 'package:pro_one/subscriptions/subscriptions_bloc.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.subscription,
    this.isExpanded = false,
    this.isBestValue = false,
  });

  final bool isExpanded;
  final bool isBestValue;
  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final monthlyCost = NumberFormat.currency(
            decimalDigits: subscription.cost.monthly % 100 == 0 ? 0 : 2,
            symbol: r'$')
        .format(subscription.cost.monthly / 100);
    final annualCost = NumberFormat.currency(
            decimalDigits: subscription.cost.annual % 100 == 0 ? 0 : 2,
            symbol: r'$')
        .format(subscription.cost.annual / 100);
    final isLoggedIn = context.select<AppBloc, bool>(
        (AppBloc bloc) => bloc.state.status == AppStatus.authenticated);

    return Card(
      shadowColor: AppColors.black,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borderOutline),
          borderRadius: BorderRadius.circular(AppSpacing.lg)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg + AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.xlg + AppSpacing.sm),
            Text(
              subscription.name.name.toUpperCase(),
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: AppColors.secondary),
            ),
            Text(
              '$monthlyCost/${l10n!.monthAbbreviation} | $annualCost/${l10n.yearAbbreviation}',
              style: theme.textTheme.headlineSmall,
            ),
            if (isBestValue) ...[
              Assets.icons.bestValue.svg(),
              const SizedBox(height: AppSpacing.md),
            ],
            if (isExpanded) ...[
              const Divider(indent: 0, endIndent: 0),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.subscriptionPurchaseBenefits.toUpperCase(),
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              )
            ],
            for (final paragraph in subscription.benefits)
              ListTile(
                title: Text(
                  paragraph,
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: AppColors.mediumHighEmphasisSurface),
                ),
                leading: const Icon(Icons.check,
                    color: AppColors.mediumHighEmphasisSurface),
                horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                dense: true,
              ),
            if (isExpanded) ...[
              const Divider(indent: 0, endIndent: 0),
              const SizedBox(height: AppSpacing.md),
              Align(
                child: Text(
                  l10n.subscriptionPurchaseCancelAnytime,
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: AppColors.mediumHighEmphasisSurface),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton.smallRedWine(
                  onPressed: isLoggedIn
                      ? () => context.read<SubscriptionsBloc>().add(
                          SubscriptionPurchaseRequested(
                              subscription: subscription))
                      : () => showAppModal<void>(
                          context: context,
                          builder: (_) => const LoginModal(),
                          routeSettings:
                              const RouteSettings(name: LoginModal.name)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isLoggedIn)
                        Text(l10n.subscriptionPurchaseButton)
                      else
                        Text(l10n.subscriptionUnauthenticatedPurchaseButton)
                    ],
                  ))
            ] else
              AppButton.smallOutlineTransparent(
                onPressed: () => ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content:
                          Text(l10n.subscriptionViewDetailsButtonSnackBar))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(l10n.subscriptionViewDetailsButton)],
                ),
              ),
            const SizedBox(height: AppSpacing.lg + AppSpacing.sm)
          ],
        ),
      ),
    );
  }
}
