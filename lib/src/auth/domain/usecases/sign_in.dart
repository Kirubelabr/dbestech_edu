import 'package:dbestech_edu/core/usecases/usecases.dart';
import 'package:dbestech_edu/core/utils/typedefs.dart';
import 'package:dbestech_edu/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignIn extends UsecaseWithParams<void, SignInParams> {
  const SignIn(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignInParams params) => _repo.signIn(
        email: params.email,
        password: params.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  const SignInParams.empty() : this(email: '', password: '');

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
