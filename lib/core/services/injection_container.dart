import 'package:dbestech_edu/src/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:dbestech_edu/src/onboarding/data/repos/onboarding_repo_impl.dart';
import 'package:dbestech_edu/src/onboarding/domain/repos/onboarding_repo.dart';
import 'package:dbestech_edu/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:dbestech_edu/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:dbestech_edu/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  // Feature => Onboarding feature
  // Business Logic
  sl
    ..registerFactory(
      () => OnboardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    // Use cases
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    // Repositories
    ..registerLazySingleton<OnboardingRepo>(() => OnboardingRepoImpl(sl()))
    // Data sources
    ..registerLazySingleton<OnboardingLocalDataSource>(
        () => OnboardingLocalDataSourceImpl(sl()))
    // External dependencies
    ..registerLazySingleton(() => prefs);
}
