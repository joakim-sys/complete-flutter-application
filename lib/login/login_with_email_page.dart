import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/login/login_bloc.dart';
import 'package:pro_one/login/login_with_email_form.dart';
import 'package:pro_one/packages/user_repository.dart';

import '../packages/app_ui/app_back_button.dart';

class LoginWithEmailPage extends StatelessWidget {
  const LoginWithEmailPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LoginWithEmailPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(userRepository: context.read<UserRepository>()),
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          actions: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close))
          ],
        ),
        body: const LoginWithEmailForm(),
      ),
    );
  }
}
