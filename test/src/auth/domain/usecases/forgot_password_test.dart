import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/src/auth/domain/repos/auth_repo.dart';
import 'package:dbestech_edu/src/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late ForgotPassword usecase;

  const tEmail = 'test email';

  setUp(
    () => {
      repo = MockAuthRepo(),
      usecase = ForgotPassword(repo),
    },
  );

  test('should call [AuthRepo.forgotPassword] when successful', () async {
    // arrange
    when(() => repo.forgotPassword(email: any(named: 'email')))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tEmail);

    // assert
    expect(result, const Right<dynamic, dynamic>(null));
    verify(() => repo.forgotPassword(email: tEmail)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
