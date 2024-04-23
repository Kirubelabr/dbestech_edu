import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dbestech_edu/core/errors/failures.dart';
import 'package:dbestech_edu/src/auth/data/models/user_model.dart';
import 'package:dbestech_edu/src/auth/domain/usecases/forgot_password.dart';
import 'package:dbestech_edu/src/auth/domain/usecases/sign_in.dart';
import 'package:dbestech_edu/src/auth/domain/usecases/sign_up.dart';
import 'package:dbestech_edu/src/auth/domain/usecases/update_user.dart';
import 'package:dbestech_edu/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tSignInParams = SignInParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user found with this identifier',
  );

  // difference between setUp and setUpAll is that
  // setUp will run everytime (whenever there's change)
  // setUpAll will only run once - it's more like init
  setUp(
    () => {
      signIn = MockSignIn(),
      signUp = MockSignUp(),
      forgotPassword = MockForgotPassword(),
      updateUser = MockUpdateUser(),
      authBloc = AuthBloc(
        signIn: signIn,
        signUp: signUp,
        forgotPassword: forgotPassword,
        updateUser: updateUser,
      ),
    },
  );

  // setUpAll run only once
  setUpAll(() {
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tUpdateUserParams);
  });

  // close the bloc to prevent a leak
  tearDown(() => authBloc.close());

  test(
    'initial state should be [AuthInitial]',
    () {
      expect(authBloc.state, const AuthInitial());
    },
  );

  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] when signIn succeeds',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => {
        bloc.add(
          SignInEvent(
            email: tSignInParams.email,
            password: tSignInParams.password,
          ),
        ),
      },
      expect: () => const [
        AuthLoading(),
        SignedIn(tUser),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when signIn fails',
        build: () {
          when(() => signIn(any()))
              .thenAnswer((_) async => Left(tServerFailure));
          return authBloc;
        },
        act: (bloc) => {
              bloc.add(
                SignInEvent(
                  email: tSignInParams.email,
                  password: tSignInParams.password,
                ),
              ),
            },
        expect: () => [
              const AuthLoading(),
              AuthError(tServerFailure.message),
            ],
        verify: (_) {
          verify(() => signIn(tSignInParams)).called(1);
          verifyNoMoreInteractions(signIn);
        });
  });

  group('SignedUp', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] when signUp succeeds',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            name: tSignUpParams.fullName,
          ),
        );
      },
      expect: () => const [
        AuthLoading(),
        SignedUp(),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signUp fails',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            name: tSignUpParams.fullName,
          ),
        );
      },
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('ForgotPasswordSent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, ForgotPasswordSent] '
      'when forgotPassword succeeds',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(ForgotPasswordEvent(email: tSignInParams.email));
      },
      expect: () => const [
        AuthLoading(),
        ForgotPasswordSent(),
      ],
      verify: (_) {
        verify(() => forgotPassword(tSignInParams.email)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] '
      'when forgotPassword fails',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(ForgotPasswordEvent(email: tSignInParams.email));
      },
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => forgotPassword(tSignInParams.email)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('UpdateUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserUpdated] when updateUser succeeds',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          UpdateUserEvent(
            userData: tUpdateUserParams.userData,
            action: tUpdateUserParams.action,
          ),
        );
      },
      expect: () => const [
        AuthLoading(),
        UserUpdated(),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when updateUser fails',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          UpdateUserEvent(
            userData: tUpdateUserParams.userData,
            action: tUpdateUserParams.action,
          ),
        );
      },
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
