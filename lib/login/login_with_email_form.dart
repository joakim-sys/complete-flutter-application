import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/login/login_bloc.dart';
import 'package:pro_one/packages/app_ui/app_button.dart';
import 'package:pro_one/packages/app_ui/app_colors.dart';
import 'package:pro_one/packages/app_ui/show_app_modal.dart';
import 'package:pro_one/terms_of_service/terms_of_service_modal.dart';

import '../gen/assets.gen.dart';
import '../magic_link_prompt/magic_link_prompt_page.dart';
import '../packages/app_ui/app_email_text_field.dart';
import '../packages/app_ui/app_spacing.dart';

class LoginWithEmailForm extends StatelessWidget {
  const LoginWithEmailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select((LoginBloc bloc) => bloc.state.email.value);
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            Navigator.of(context)
                .push<void>(MagicLinkPromptPage.route(email: email));
          } else if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text(context.l10n!.loginWithEmailFailure)));
          }
        },
        child: const CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.xlg, AppSpacing.lg,
                    AppSpacing.xlg, AppSpacing.xxlg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _HeaderTitle(),
                    SizedBox(height: AppSpacing.xxxlg),
                    _EmailInput(),
                    _TermsAndPrivacyPolicyLinkTexts(),
                    Spacer(),
                    _NextButton(),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      context.l10n!.loginWithEmailHeaderText,
      style: theme.textTheme.displaySmall,
    );
  }
}

class _EmailInput extends StatefulWidget {
  const _EmailInput({super.key});

  @override
  State<_EmailInput> createState() => __EmailInputState();
}

class __EmailInputState extends State<_EmailInput> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;

    return AppEmailTextField(
      controller: _controller,
      readOnly: state.status.isInProgress,
      hintText: context.l10n!.loginWithEmailTextFieldHint,
      onChanged: (email) =>
          context.read<LoginBloc>().add(LoginEmailChanged(email)),
      suffix: ClearIconButton(
          onPressed: !state.status.isInProgress
              ? () {
                  _controller.clear();
                  context.read<LoginBloc>().add(const LoginEmailChanged(''));
                }
              : null),
    );
  }
}

class ClearIconButton extends StatelessWidget {
  const ClearIconButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final suffixVisible =
        context.select((LoginBloc bloc) => bloc.state.email.value.isNotEmpty);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: Visibility(
          visible: suffixVisible,
          child: GestureDetector(
            onTap: onPressed,
            child: Assets.icons.closeCircle.svg(),
          )),
    );
  }
}

class _TermsAndPrivacyPolicyLinkTexts extends StatelessWidget {
  const _TermsAndPrivacyPolicyLinkTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: context.l10n!.loginWithEmailSubtitleText,
                style: theme.textTheme.bodyLarge),
            TextSpan(
                text: context.l10n!.loginWithEmailTermsAndPrivacyPolicyText,
                style:
                    theme.textTheme.bodyLarge?.apply(color: AppColors.darkAqua),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => showAppModal<void>(
                      context: context,
                      builder: (context) => const TermsOfServiceModal())),
            TextSpan(text: '.', style: theme.textTheme.bodyLarge)
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<LoginBloc>().state;
    return AppButton.darkAqua(
        onPressed: state.valid
            ? () => context.read<LoginBloc>().add(SendEmailLinkSubmitted())
            : null,
        child: state.status.isInProgress
            ? const SizedBox.square(
                dimension: 24, child: CircularProgressIndicator())
            : Text(l10n!.nextButtonText));
  }
}
