import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/navigation/nav_drawer_sections.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_logo.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/subscriptions/purchase_subscription_dialog.dart';

import '../packages/app_ui/app_button.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});
  static const _contentPadding = AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(AppSpacing.lg),
          bottomRight: Radius.circular(AppSpacing.lg)),
      child: Drawer(
        backgroundColor: AppColors.darkBackground,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: _contentPadding + AppSpacing.xxs,
                  horizontal: _contentPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppLogo.light(),
              ),
            ),
            const _NavDrawerDivider(),
            const NavDrawerSections(),
            if (!isUserSubscribed) ...const [
              _NavDrawerDivider(),
              NavDrawerSubscribe(),
              SizedBox(height: AppSpacing.xlg),
              NavDrawerSubscribeButton(),
            ]
          ],
        ),
      ),
    );
  }
}

class _NavDrawerDivider extends StatelessWidget {
  const _NavDrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.outlineOnDark);
  }
}

class NavDrawerSubscribe extends StatelessWidget {
  const NavDrawerSubscribe({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        NavDrawerSubscribeTitle(),
        NavDrawerSubscribeSubtitle(),
      ],
    );
  }
}

class NavDrawerSubscribeTitle extends StatelessWidget {
  const NavDrawerSubscribeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg + AppSpacing.xxs),
        child: Text(
          l10n!.navigationDrawerSubscribeTitle,
          style: theme.textTheme.titleMedium
              ?.copyWith(color: AppColors.highEmphasisPrimary),
        ),
      ),
    );
  }
}

class NavDrawerSubscribeSubtitle extends StatelessWidget {
  const NavDrawerSubscribeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        l10n!.navigationDrawerSubscribeSubtitle,
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: AppColors.mediumEmphasisPrimary),
      ),
    );
  }
}

class NavDrawerSubscribeButton extends StatelessWidget {
  const NavDrawerSubscribeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton.redWine(
      onPressed: () => showPurchaseSubscriptionDialog(context: context),
      child: Text(context.l10n!.subscribeButtonText),
    );
  }
}
