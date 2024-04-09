import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/core/errors/failures.dart';
import 'package:dbestech_edu/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:dbestech_edu/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:dbestech_edu/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnboardingCubit cubit;

  final tFailure =
      CacheFailure(message: 'Something went wrong', statusCode: 500);

  setUp(() => {
        cacheFirstTimer = MockCacheFirstTimer(),
        checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer(),
        cubit = OnboardingCubit(
          cacheFirstTimer: cacheFirstTimer,
          checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
        ),
      });

  tearDown(() => cubit.close());

  test('initial state should be [OnboardingInitial]', () async {
    expect(cubit.state, const OnboardingInitial());
  });

  group('cacheFirstTimer', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CachingFirstTimer] and [UserCached] on success',
      build: () {
        when(() => cacheFirstTimer())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const [
        CachingFirstTimer(),
        UserCached(),
      ],
      verify: (_) => {
        verify(() => cacheFirstTimer()).called(1),
        verifyNoMoreInteractions(cacheFirstTimer),
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CachingFirstTimer] and [OnboardingError] when in failure',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer(
          (_) async => Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => [
        const CachingFirstTimer(),
        OnboardingError(message: tFailure.message),
      ],
      verify: (_) => {
        verify(() => cacheFirstTimer()).called(1),
        verifyNoMoreInteractions(cacheFirstTimer),
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CheckingIfUserIsFirstTimer] and [OnboardingStatus] on success',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => const Right(false));
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const [
        CheckingIfUserIsFirstTimer(),
        OnboardingStatus(isFirstTimer: false),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'should emit [CheckingIfUserIsFirstTimer] and [OnboardingStatus] to be true '
      'on failure',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const [
        CheckingIfUserIsFirstTimer(),
        OnboardingStatus(isFirstTimer: true),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
