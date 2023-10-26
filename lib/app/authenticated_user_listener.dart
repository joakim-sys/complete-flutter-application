import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/analytics/analytics_bloc.dart';
import 'package:pro_one/app/app_bloc.dart';
import 'package:pro_one/packages/ntg_event.dart';

class AuthenticatedUserListener extends StatelessWidget {
  const AuthenticatedUserListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          context.read<AnalyticsBloc>().add(TrackAnalyticsEvent(
              state.user.isNewUser ? RegistrationEvent() : LoginEvent()));
        }
      },
      listenWhen: (previous, current) => previous.status != current.status,
      child: child,
    );
  }
}
