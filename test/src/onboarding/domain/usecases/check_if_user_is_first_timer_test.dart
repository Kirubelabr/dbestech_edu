import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'onboarding_repo.mock.dart';

void main() {
  late MockOnboardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(
    () => {
      repo = MockOnboardingRepo(),
      usecase = CheckIfUserIsFirstTimer(repo),
    },
  );

  test(
    'should get a response from MockOnboardingRepo',
    () async {
      // arrange (stubbing)
      when(() => repo.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await usecase();

      // assert
      expect(result, equals(const Right<dynamic, bool>(true)));
      verify(() => repo.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
