import 'package:equatable/equatable.dart';

class AuthenticationUser extends Equatable {
  const AuthenticationUser({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.isNewUser = true,
  });

  final String? email;

  final String id;

  final String? name;

  final String? photo;

  final bool isNewUser;

  bool get isAnonymous => this == anonymous;

  static const anonymous = AuthenticationUser(id: '');

  @override
  List<Object?> get props => [email, id, name, photo, isNewUser];
}

abstract class AuthenticationException implements Exception {
  const AuthenticationException(this.error);

  final Object error;
}

class SendLoginEmailLinkFailure extends AuthenticationException {
  const SendLoginEmailLinkFailure(super.error);
}

class IsLogInWithEmailLinkFailure extends AuthenticationException {
  const IsLogInWithEmailLinkFailure(super.error);
}

class LogInWithEmailLinkFailure extends AuthenticationException {
  const LogInWithEmailLinkFailure(super.error);
}

class LogInWithAppleFailure extends AuthenticationException {
  const LogInWithAppleFailure(super.error);
}

class LogInWithGoogleFailure extends AuthenticationException {
  const LogInWithGoogleFailure(super.error);
}

class LogInWithGoogleCanceled extends AuthenticationException {
  const LogInWithGoogleCanceled(super.error);
}

class LogInWithFacebookFailure extends AuthenticationException {
  const LogInWithFacebookFailure(super.error);
}

class LogInWithFacebookCanceled extends AuthenticationException {
  const LogInWithFacebookCanceled(super.error);
}

class LogInWithTwitterFailure extends AuthenticationException {
  const LogInWithTwitterFailure(super.error);
}

class LogInWithTwitterCanceled extends AuthenticationException {
  const LogInWithTwitterCanceled(super.error);
}

class LogOutFailure extends AuthenticationException {
  const LogOutFailure(super.error);
}

abstract class AuthenticationClient {
  Stream<AuthenticationUser> get user;

  Future<void> logInWithApple();
  Future<void> logInWithGoogle();
  Future<void> logInWithFacebook();
  Future<void> logInWithTwitter();

  Future<void> sendLoginEmailLink({
    required String email,
    required String appPackageName,
  });

  bool isLogInWithEmailLink({
    required String emailLink,
  });

  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  });

  Future<void> logOut();
}
