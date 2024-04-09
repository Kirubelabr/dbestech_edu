import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/core/enums/update_users.dart';
import 'package:dbestech_edu/core/errors/failures.dart';
import 'package:dbestech_edu/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo mockAuthRepo;
  late UpdateUser updateUser;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    updateUser = UpdateUser(mockAuthRepo);
    registerFallbackValue(UpdateUserAction.displayName);
  });

  const tUpdateUserParams = UpdateUserParams(
    action: UpdateUserAction.displayName,
    userData: 'testUserData',
  );

  test('should update user when provided valid parameters', () async {
    when(() => mockAuthRepo.updateUser(action: any(named: 'action')))
        .thenAnswer((_) async => const Right<Failure, void>(null));

    final result = await updateUser(tUpdateUserParams);

    expect(result, const Right<Failure, void>(null));
    verify(() => mockAuthRepo.updateUser(action: tUpdateUserParams.action))
        .called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });
}
