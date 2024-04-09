import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/src/auth/domain/entities/user.dart';
import 'package:dbestech_edu/src/auth/domain/repos/auth_repo.dart';
import 'package:dbestech_edu/src/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignUp usecase;

  const tEmail = 'test email';
  const tFullName = 'test full name';
  const tPassword = 'test password';

  const tUser = LocalUser.empty();

  setUp(
    () => {
      repo = MockAuthRepo(),
      usecase = SignUp(repo),
    },
  );

  test('should call the [AuthRepo.signUp]', () async {
    // arrange / stub
    when(
      () => repo.signUp(
        email: any(named: 'email'),
        fullName: any(named: 'fullName'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase(
      const SignUpParams(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      ),
    );

    // assert
    expect(result, const Right<dynamic, LocalUser>(tUser));
    verify(
      () =>
          repo.signUp(email: tEmail, fullName: tFullName, password: tPassword),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
