import 'package:flutter/material.dart';
import 'package:pro_one/gen/assets.gen.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/packages/app_ui/app_button.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';

import '../packages/app_ui/app_spacing.dart';
import '../packages/email_launcher.dart';

class MagicLinkPromptView extends StatelessWidget {
  const MagicLinkPromptView({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xlg, AppSpacing.xlg,
                AppSpacing.xlg, AppSpacing.xxlg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MagicLinkPromptHeader(),
                const SizedBox(height: AppSpacing.xxxlg),
                Assets.icons.envelopeOpen.svg(),
                const SizedBox(height: AppSpacing.xxxlg),
                MagicLikPromptSubtitle(email: email),
                const Spacer(),
                MagicLinkPromptOpenEmailButton()
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MagicLinkPromptHeader extends StatelessWidget {
  const MagicLinkPromptHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n!.magicLinkPromptHeader,
        style: Theme.of(context).textTheme.displaySmall);
  }
}

class MagicLikPromptSubtitle extends StatelessWidget {
  const MagicLikPromptSubtitle({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          context.l10n!.magicLinkPromptTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        Text(
          email,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.apply(color: AppColors.darkAqua),
        ),
        const SizedBox(height: AppSpacing.xxlg),
        Text(
          context.l10n!.magicLinkPromptSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        )
      ],
    );
  }
}

class MagicLinkPromptOpenEmailButton extends StatelessWidget {
  MagicLinkPromptOpenEmailButton({
    EmailLauncher? emailLauncher,
    super.key,
  }) : _emailLauncher = emailLauncher ?? EmailLauncher();

  final EmailLauncher _emailLauncher;

  @override
  Widget build(BuildContext context) {
    return AppButton.darkAqua(
      onPressed: _emailLauncher.launchEmailApp,
      child: Text(context.l10n!.openMailAppButtonText),
    );
  }
}
