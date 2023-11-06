import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/gen/assets.gen.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/login/login_modal.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/app_ui/show_app_modal.dart';
import 'package:pro_one/user_profile/user_profile_page.dart';

class UserProfileButton extends StatelessWidget {
  const UserProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isAnonymous =
        context.select<AppBloc, bool>((bloc) => bloc.state.user.isAnonymous);

    // return isAnonymous ? const LoginButton() : const OpenProfileButton();
    return const OpenProfileButton();
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showAppModal<void>(
          context: context,
          builder: (context) => const LoginModal(),
          routeSettings: const RouteSettings(name: LoginModal.name)),
      iconSize: 24,
      icon: Assets.icons.logInIcon.svg(),
      tooltip: context.l10n!.loginTooltip,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
    );
  }
}

class OpenProfileButton extends StatelessWidget {
  const OpenProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).push(UserProfilePage.route()),
      icon: Assets.icons.profileIcon.svg(),
      iconSize: 24,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      tooltip: context.l10n!.openProfileTooltip,
    );
  }
}
