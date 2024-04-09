import 'package:dbestech_edu/core/usecases/usecases.dart';
import 'package:dbestech_edu/core/utils/typedefs.dart';
import 'package:dbestech_edu/src/auth/domain/repos/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  const ForgotPassword(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String params) => _repo.forgotPassword(email: params);
}
