import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/analytics/analytics_bloc.dart';
import 'package:pro_one/gen/assets.gen.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/notification_preferences/notification_preferences_page.dart';
import 'package:pro_one/packages/app_ui/app_back_button.dart';
import 'package:pro_one/packages/app_ui/app_button.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/app_switch.dart';
import 'package:pro_one/packages/notifications_repository.dart';
import 'package:pro_one/packages/ntg_event.dart';
import 'package:pro_one/packages/user_repository.dart';
import 'package:pro_one/subscriptions/purchase_subscription_dialog.dart';
import 'package:pro_one/user_profile/user_profile_bloc.dart';
import 'package:pro_one/user_profile/user_profile_subscribe_box.dart';

import '../app/app_bloc.dart';
import '../subscriptions/manage_subscription_page.dart';
import '../terms_of_service/terms_of_service_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const UserProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileBloc(
          userRepository: context.read<UserRepository>(),
          notificationsRepository: context.read<NotificationsRepository>()),
      child: const UserProfileView(),
    );
  }
}

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<UserProfileBloc>().add(const FetchNotificationsEnabled());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsFlutterBinding.ensureInitialized();
      context.read<UserProfileBloc>().add(const FetchNotificationsEnabled());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProfileBloc bloc) => bloc.state.user);
    final notificationsEnabled = context
        .select((UserProfileBloc bloc) => bloc.state.notificationsEnabled);
    final isUserSubscribed =
        context.select<AppBloc, bool>((bloc) => bloc.state.isUserSubscribed);

    final l10n = context.l10n!;

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state.status == UserProfileStatus.togglingNotificationsSucceeded &&
            state.notificationsEnabled) {
          context
              .read<AnalyticsBloc>()
              .add(TrackAnalyticsEvent(PushNotificationSubscriptionEvent()));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const UserProfileTitle(),
                  // TODO: Negate this statement with !
                  if (!user.isAnonymous) ...[
                    UserProfileItem(
                      title: user.email ?? '',
                      leading: Assets.icons.profileIcon.svg(),
                    ),
                    const UserProfileLogoutButton(),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  const _UserProfileDivider(),

                  UserProfileSubtitle(
                    subtitle: l10n.userProfileSubscriptionDetailsSubtitle,
                  ),
                  // TODO: Negate statement
                  if (!isUserSubscribed)
                    UserProfileItem(
                      title: l10n.manageSubscriptionTile,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context)
                          .push(ManageSubscriptionPage.route()),
                    )
                  else
                    UserProfileSubscribeBox(
                        onSubscribePressed: () =>
                            showPurchaseSubscriptionDialog(context: context)),

                  const _UserProfileDivider(),
                  UserProfileSubtitle(
                      subtitle: l10n.userProfileSettingsSubtitle),
                  UserProfileItem(
                    leading: Assets.icons.notificationsIcon.svg(),
                    title: l10n.userProfileSettingsNotificationsTitle,
                    trailing: AppSwitch(
                      value: notificationsEnabled,
                      onChanged: (_) => context
                          .read<UserProfileBloc>()
                          .add(const ToggleNotifications()),
                      onText: l10n.checkboxOnTitle,
                      offText: l10n.userProfileCheckboxOffTitle,
                    ),
                  ),

                  UserProfileItem(
                    title: l10n.notificationPreferencesTitle,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context)
                        .push(NotificationPreferencesPage.route()),
                  ),
                  const _UserProfileDivider(),
                  UserProfileSubtitle(subtitle: l10n.userProfileLegalSubtitle),
                  UserProfileItem(
                    title: l10n.userProfileLegalTermsOfUseAndPrivacyPolicyTitle,
                    onTap: () => Navigator.of(context)
                        .push<void>(TermsOfServicePage.route()),
                    leading: Assets.icons.termsOfUseIcon.svg(),
                  ),
                  UserProfileItem(
                    title: l10n.userProfileLegalAboutTitle,
                    leading: Assets.icons.aboutIcon.svg(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        context.l10n!.userProfileTitle,
        style: theme.textTheme.displaySmall,
      ),
    );
  }
}

class UserProfileSubtitle extends StatelessWidget {
  const UserProfileSubtitle({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
      child: Text(subtitle, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class UserProfileItem extends StatelessWidget {
  const UserProfileItem(
      {super.key,
      required this.title,
      this.leading,
      this.trailing,
      this.onTap});

  static const _leadingWidth = AppSpacing.xxxlg + AppSpacing.sm;

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null;
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: hasLeading ? _leadingWidth : 0,
        child: leading,
      ),
      trailing: trailing,
      dense: true,
      horizontalTitleGap: 0,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
      contentPadding: EdgeInsets.fromLTRB(hasLeading ? 0 : AppSpacing.xlg,
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: AppColors.highEmphasisSurface),
      ),
    );
  }
}

class _UserProfileDivider extends StatelessWidget {
  const _UserProfileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Divider(
        color: AppColors.borderOutline,
        indent: 0,
        endIndent: 0,
      ),
    );
  }
}

class UserProfileLogoutButton extends StatelessWidget {
  const UserProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + AppSpacing.xxlg),
      child: AppButton.smallDarkAqua(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.logOutIcon.svg(),
            const SizedBox(width: AppSpacing.sm),
            Text(context.l10n!.userProfileLogoutButtonText)
          ],
        ),
        onPressed: () =>
            context.read<AppBloc>().add(const AppLogoutRequested()),
      ),
    );
  }
}
