import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/core/errors/exceptions.dart';
import 'package:dbestech_edu/core/errors/failures.dart';
import 'package:dbestech_edu/core/utils/typedefs.dart';
import 'package:dbestech_edu/src/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:dbestech_edu/src/onboarding/domain/repos/onboarding_repo.dart';

class OnboardingRepoImpl implements OnboardingRepo {
  const OnboardingRepoImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await _localDataSource.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTimer() async {
    try {
      final result = await _localDataSource.checkIfUserIsFirstTimer();
      return Right(result);
    } on CacheException catch(e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
