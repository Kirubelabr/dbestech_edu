import 'package:dbestech_edu/core/errors/exceptions.dart';
import 'package:dbestech_edu/src/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnboardingLocalDataSource localDataSource;

  setUp(
    () => {
      prefs = MockSharedPreferences(),
      localDataSource = OnboardingLocalDataSourceImpl(prefs),
    },
  );

  group('cacheFirstTimer', () {
    test(
      'should call [SharedPreferences] to cache the data',
      () async {
        // arrange
        when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

        // act
        await localDataSource.cacheFirstTimer();

        // assert
        verify(() => prefs.setBool(kFirstTimerKey, false));
        verifyNoMoreInteractions(prefs);
      },
    );
    test(
      'should throw [CacheException] on failure',
      () async {
        // arrange
        when(() => prefs.setBool(any(), any())).thenThrow(Exception());

        // act
        final methodCall = localDataSource.cacheFirstTimer;

        // assert
        expect(methodCall, throwsA(isA<CacheException>()));
        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    test(
      'should call [SharedPreferences] to check if user is first timer '
      'and return the right data from storage exists',
      () async {
        // arrange
        when(() => prefs.getBool(any())).thenReturn(false);

        // act
        final result = await localDataSource.checkIfUserIsFirstTimer();

        // assert
        expect(result, false);
        verify(() => prefs.getBool(kFirstTimerKey));
        verifyNoMoreInteractions(prefs);
      },
    );

    test(
      'should return true if there is no data in storage',
      () async {
        // arrange
        when(() => prefs.getBool(kFirstTimerKey)).thenReturn(null);

        // act
        final result = await localDataSource.checkIfUserIsFirstTimer();

        // assert
        expect(result, true);
        verify(() => prefs.getBool(kFirstTimerKey)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );
    test(
      'should throw [CacheException] when there is error retrieving the data',
          () async {
        // arrange
        when(() => prefs.getBool(any())).thenThrow(Exception());

        // act
        final methodCall = localDataSource.checkIfUserIsFirstTimer;

        // assert
        expect(methodCall, throwsA(isA<CacheException>()));
        verify(() => prefs.getBool(kFirstTimerKey)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );
  });
}
