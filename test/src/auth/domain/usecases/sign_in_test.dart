import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/src/auth/domain/entities/user.dart';
import 'package:dbestech_edu/src/auth/domain/repos/auth_repo.dart';
import 'package:dbestech_edu/src/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignIn usecase;

  const tEmail = 'test email';
  const tPassword = 'test password';

  const tUser = LocalUser.empty();

  setUp(
    () => {
      repo = MockAuthRepo(),
      usecase = SignIn(repo),
    },
  );

  test('should return [LocalUser] data from the AuthRepo', () async {
    // arrange / stub
    when(
      () => repo.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase(
      const SignInParams(email: tEmail, password: tPassword),
    );

    // assert
    expect(result, const Right<dynamic, LocalUser>(tUser));
    verify(() => repo.signIn(email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
