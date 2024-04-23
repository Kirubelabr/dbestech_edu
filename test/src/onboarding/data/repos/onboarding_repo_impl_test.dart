import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/core/errors/exceptions.dart';
import 'package:dbestech_edu/core/errors/failures.dart';
import 'package:dbestech_edu/src/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:dbestech_edu/src/onboarding/data/repos/onboarding_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnboardingLocalDataSource extends Mock
    implements OnboardingLocalDataSource {}

void main() {
  late OnboardingLocalDataSource localDataSource;
  late OnboardingRepoImpl repoImpl;

  setUp(
    () => {
      localDataSource = MockOnboardingLocalDataSource(),
      repoImpl = OnboardingRepoImpl(localDataSource),
    },
  );

  test('should be a subclass of [OnboardingRepo]', () {
    expect(repoImpl, isA<OnboardingRepoImpl>());
  });

  group('cacheFirstTimer', () {
    test(
        'should complete successfully when call to '
        'localDataSource is successful', () async {
      // arrange
      when(() => localDataSource.cacheFirstTimer()).thenAnswer(
        (_) async => Future.value(),
      );

      // act
      final result = await repoImpl.cacheFirstTimer();

      // assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test('should return [CacheFailure] when call to localDataSource failed',
        () async {
      // arrange
      when(() => localDataSource.cacheFirstTimer()).thenThrow(
        const CacheException(message: 'Insufficient Storage'),
      );

      // act
      final result = await repoImpl.cacheFirstTimer();

      // assert
      expect(
        result,
        equals(
          Left<CacheFailure, dynamic>(
            CacheFailure(message: 'Insufficient Storage', statusCode: 500),
          ),
        ),
      );
      verify(() => localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
  });

  group('checkIfUserIsFirstTimer', () {
    test(
        'should return true when user is first timer', () async {
      // arrange
      when(() => localDataSource.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => Future.value(true));

      // act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      // assert
      expect(result, equals(const Right<dynamic, bool>(true)));
      verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return false if user is NOT a first timer', () async {
      // arrange
      when(() => localDataSource.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => Future.value(false));

      // act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      // assert
      expect(result, equals(const Right<dynamic, bool>(false)));
      verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test('should return [CacheFailure] when call to localDataSource failed',
            () async {
          // arrange
          when(() => localDataSource.checkIfUserIsFirstTimer()).thenThrow(
            const CacheException(message: 'Insufficient Storage'),
          );

          // act
          final result = await repoImpl.checkIfUserIsFirstTimer();

          // assert
          expect(
            result,
            equals(
              Left<CacheFailure, dynamic>(
                CacheFailure(message: 'Insufficient Storage', statusCode: 500),
              ),
            ),
          );
          verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        });
  });
}
