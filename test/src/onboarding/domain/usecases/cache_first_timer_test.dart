import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/core/errors/failures.dart';
import 'package:dbestech_edu/src/onboarding/domain/repos/onboarding_repo.dart';
import 'package:dbestech_edu/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'onboarding_repo.mock.dart';

void main() {
  late OnboardingRepo repo;
  late CacheFirstTimer usecase;

  setUp(
    () => {
      repo = MockOnboardingRepo(),
      usecase = CacheFirstTimer(repo),
    },
  );

  test(
    'should call [OnboardingRepo.cacheFirstTimer] and return the correct data',
    () async {
      when(() => repo.cacheFirstTimer()).thenAnswer(
        (_) async => Left(
          APIFailure(message: 'Unknown Error Occurred', statusCode: 500),
        ),
      );

      final result = await usecase();

      expect(
          result,
          equals(
            Left<Failure, dynamic>(
              APIFailure(message: 'Unknown Error Occurred', statusCode: 500),
            ),
          ));

      verify(() => repo.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
