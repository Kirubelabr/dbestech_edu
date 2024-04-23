part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String name;
  final String password;

  @override
  List<String> get props => [email, name, password];
}

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent({required this.email});

  final String email;

  @override
  List<String> get props => [email];
}

class UpdateUserEvent extends AuthEvent {
  UpdateUserEvent({required this.userData, required this.action})
      : assert(
            userData is String || userData is File,
            '[userData] should be either String or File but got '
            '${userData.runtimeType}');

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];
}
