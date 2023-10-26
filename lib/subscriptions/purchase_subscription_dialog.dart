import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/analytics/analytics_bloc.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/in_app_purchase_repository.dart';
import 'package:pro_one/packages/ntg_event.dart';
import 'package:pro_one/packages/user_repository.dart';
import 'package:pro_one/subscriptions/subscription_card.dart';
import 'package:pro_one/subscriptions/subscriptions_bloc.dart';

Future<void> showPurchaseSubscriptionDialog(
        {required BuildContext context}) async =>
    showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) => const PurchaseSubscriptionDialog(),
        transitionBuilder: (context, anim1, anim2, child) => SlideTransition(
              position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                  .animate(anim1),
              child: child,
            ));

class PurchaseSubscriptionDialog extends StatelessWidget {
  const PurchaseSubscriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionsBloc>(
      create: (context) => SubscriptionsBloc(
          inAppPurchaseRepository: context.read<InAppPurchaseRepository>(),
          userRepository: context.read<UserRepository>())
        ..add(SubscriptionsRequested()),
      child: const PurchaseSubscriptionDialogView(),
    );
  }
}

class PurchaseSubscriptionDialogView extends StatelessWidget {
  const PurchaseSubscriptionDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Stack(
      children: [
        Scaffold(
          body: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: AppColors.modalBackground,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n!.subscriptionPurchaseTitle,
                            style: theme.textTheme.displaySmall),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    Text(l10n.subscriptionPurchaseSubtitle,
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xlg),
                    Expanded(
                        child:
                            BlocConsumer<SubscriptionsBloc, SubscriptionsState>(
                      builder: ((context, state) {
                        if (state.subscriptions.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return CustomScrollView(
                            slivers: [
                              SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) => SubscriptionCard(
                                            subscription:
                                                state.subscriptions[index],
                                            isExpanded: index == 0,
                                          ),
                                      childCount: state.subscriptions.length))
                            ],
                          );
                        }
                      }),
                      listener: ((context, state) {
                        // if (true) {
                        if (state.purchaseStatus == PurchaseStatus.completed) {
                          context.read<AnalyticsBloc>().add(TrackAnalyticsEvent(
                              UserSubscriptionConversionEvent()));
                          showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const PurchaseCompletedDialog())
                              .then((value) => Navigator.maybePop(context));
                        }
                      }),
                    ))
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PurchaseCompletedDialog extends StatefulWidget {
  const PurchaseCompletedDialog({super.key});

  @override
  State<PurchaseCompletedDialog> createState() =>
      _PurchaseCompletedDialogState();
}

class _PurchaseCompletedDialogState extends State<PurchaseCompletedDialog> {
  late Timer _timer;
  static const _closeDialogAfterDuration = Duration(seconds: 3);

  @override
  void initState() {
    _timer =
        Timer(_closeDialogAfterDuration, () => Navigator.maybePop(context));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg, horizontal: AppSpacing.xxlg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.md),
              const Icon(
                Icons.check_circle_outline,
                size: AppSpacing.xxlg + AppSpacing.xxlg,
                color: AppColors.mediumEmphasisSurface,
              ),
              const SizedBox(height: AppSpacing.xlg),
              Text(context.l10n!.subscriptionPurchaseCompleted,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md)
            ],
          ),
        ),
      ),
    );
  }
}
