import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/login/login_bloc.dart';
import 'package:pro_one/packages/user_repository.dart';

import 'login_form.dart';

class LoginModal extends StatelessWidget {
  const LoginModal({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LoginModal());

  static const String name = '/loginModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            LoginBloc(userRepository: context.read<UserRepository>()),
        child: const LoginForm());
  }
}
