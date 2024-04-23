part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _onboardingInit();
  await _authInit();
}

Future<void> _authInit() async {
  // Feature => AuthBloc
  // Business Logic
  sl
    ..registerLazySingleton(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    // Usecases
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    // Repositories
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    // External dependencies
    ..registerLazySingleton(() => fba.FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _onboardingInit() async {
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
      () => OnboardingLocalDataSourceImpl(sl()),
    )
// External dependencies
    ..registerLazySingleton(() => prefs);
}
