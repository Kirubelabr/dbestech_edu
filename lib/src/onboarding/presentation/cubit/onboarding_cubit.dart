import 'package:bloc/bloc.dart';
import 'package:dbestech_edu/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:dbestech_edu/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required CacheFirstTimer cacheFirstTimer,
    required CheckIfUserIsFirstTimer checkIfUserIsFirstTimer,
  })
      : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserIsFirstTimer = checkIfUserIsFirstTimer,
        super(const OnboardingInitial());

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserIsFirstTimer _checkIfUserIsFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    final result = await _cacheFirstTimer();

    result.fold(
          (failure) => emit(OnboardingError(message: failure.message)),
          (r) => emit(const UserCached()),
    );
  }

  Future<void> checkIfUserIsFirstTimer() async {
    emit(const CheckingIfUserIsFirstTimer());
        final result = await _checkIfUserIsFirstTimer();

    result.fold(
          (failure) => emit(const OnboardingStatus(isFirstTimer: true)),
          (status) =>
          emit(
            OnboardingStatus(isFirstTimer: status),
          ),
    );
  }
}
