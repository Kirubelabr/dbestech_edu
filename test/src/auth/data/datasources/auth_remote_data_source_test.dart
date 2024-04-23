import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbestech_edu/core/enums/update_users.dart';
import 'package:dbestech_edu/core/errors/exceptions.dart';
import 'package:dbestech_edu/core/utils/constants.dart';
import 'package:dbestech_edu/core/utils/typedefs.dart';
import 'package:dbestech_edu/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dbestech_edu/src/auth/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredentials extends Mock implements UserCredential {
  MockUserCredentials([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late UserCredential userCredential;
  late AuthRemoteDataSource dataSource;
  late DocumentReference<DataMap> documentReference;
  late MockUser mockUser;

  const tUser = LocalUserModel.empty();

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    documentReference = cloudStoreClient.collection(usersCollectionName).doc();
    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );
    dbClient = MockFirebaseStorage();
    mockUser = MockUser()..uid = documentReference.id;
    userCredential = MockUserCredentials(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );

    // stub here to avoid complications
    when(() => authClient.currentUser).thenAnswer((_) => mockUser);
  });

  const tEmail = 'Test Email';
  const tFullName = 'Test FullName';
  const tPassword = 'Test password';

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no record with the corresponding identifier',
  );

  group('forgotPassword', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
        ).thenAnswer((_) async => Future.value());

        final call = dataSource.forgotPassword(tEmail);

        expect(call, completes);

        verify(() => authClient.sendPasswordResetEmail(email: tEmail))
            .called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
      // arrange
      when(
        () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenThrow(tFirebaseAuthException);

      // act
      final call = dataSource
          .forgotPassword; // when testing for errors we invoke it in expect

      // assert
      expect(() => call(tEmail), throwsA(isA<ServerException>()));

      verify(() => authClient.sendPasswordResetEmail(email: tEmail)).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });

  group('signIn', () {
    final emptyCredentials = MockUserCredentials();

    test(
      'should return [LocalUserModel] when no [Exception] is thrown',
      () async {
        // arrange
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        // act
        final result =
            await dataSource.signIn(email: tEmail, password: tPassword);

        // assert
        expect(result.uid, userCredential.user!.uid);
        expect(result.points, 0);

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when no user is found due to various reasons',
      () async {
        // arrange
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => emptyCredentials);

        // act
        final call = dataSource.signIn(email: tEmail, password: tPassword);

        // assert
        expect(call, throwsA(isA<ServerException>()));
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        // arrange
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        // act
        final call = dataSource.signIn;

        // assert
        expect(
          () => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()),
        );
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('signUp', () {
    test(
      'should complete successfully when no [Exception] is thrown ',
      () async {
        // arrange
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(
              named: 'password',
            ),
          ),
        ).thenAnswer((_) async => userCredential);
        when(() => userCredential.user?.updateDisplayName(any()))
            .thenAnswer((_) async => Future.value());
        when(() => userCredential.user?.updatePhotoURL(any()))
            .thenAnswer((_) async => Future.value());

        // act
        final call = dataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        );

        // assert
        expect(call, completes);

        await untilCalled(() => userCredential.user?.updateDisplayName(any()));
        await untilCalled(() => userCredential.user?.updatePhotoURL(any()));

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        verify(() => userCredential.user?.updateDisplayName(tFullName))
            .called(1);
        verify(() => userCredential.user?.updatePhotoURL(kDefaultAvatar))
            .called(1);

        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        // arrange
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        // act
        final call = dataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        );

        // assert
        expect(call, throwsA(isA<ServerException>()));
        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
      },
    );
  });

  group('updateUser', () {
    setUp(
      () => {registerFallbackValue(MockAuthCredential())},
    );

    test('should update displayName when no [Exception] is thrown', () async {
      // arrange
      when(() => mockUser.updateDisplayName(any()))
          .thenAnswer((_) async => Future.value());

      await dataSource.updateUser(
        action: UpdateUserAction.displayName,
        userData: tFullName,
      );

      verify(() => mockUser.updateDisplayName(tFullName)).called(1);

      // check nothing else is updated
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));

      final userData = await cloudStoreClient
          .collection(usersCollectionName)
          .doc(mockUser.uid)
          .get();

      // assert
      expect(userData.data()!['fullName'], tFullName);
    });

    test('should update email when no [Exception] is thrown', () async {
      // arrange
      when(() => mockUser.verifyBeforeUpdateEmail(any()))
          .thenAnswer((_) async => Future.value());

      await dataSource.updateUser(
        action: UpdateUserAction.email,
        userData: tEmail,
      );

      verify(() => mockUser.verifyBeforeUpdateEmail(tEmail)).called(1);

      // check nothing else is updated
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));

      final userData = await cloudStoreClient
          .collection(usersCollectionName)
          .doc(mockUser.uid)
          .get();

      // assert
      expect(userData.data()!['email'], tEmail);
    });

    test('should update bio when no [Exception] is thrown', () async {
      // arrange
      const newBio = 'new bio';

      await dataSource.updateUser(
        action: UpdateUserAction.bio,
        userData: newBio,
      );

      final userData = await cloudStoreClient
          .collection(usersCollectionName)
          .doc(mockUser.uid)
          .get();

      expect(userData.data()!['bio'], newBio);

      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updatePassword(any()));
    });

    test(
      'should update password when no [Exception] is thrown',
      () async {
        when(() => mockUser.updatePassword(any()))
            .thenAnswer((_) async => Future.value());

        when(() => mockUser.reauthenticateWithCredential(any()))
            .thenAnswer((_) async => userCredential);

        when(() => mockUser.email).thenAnswer((_) => tEmail);

        await dataSource.updateUser(
          action: UpdateUserAction.password,
          userData: jsonEncode({
            'oldPassword': 'oldPassword',
            'newPassword': tPassword,
          }),
        );

        verify(() => mockUser.updatePassword(tPassword)).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updateDisplayName(any()));
      },
    );

    test(
      'should update profile picture when no [Exception] is thrown',
      () async {
        final newProfilePic = File('assets/images/onBoarding_background.png');
        when(() => mockUser.updatePhotoURL(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.profilePic,
          userData: newProfilePic,
        );

        verify(() => mockUser.updatePhotoURL(any())).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateDisplayName(any()));

        expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
      },
    );
  });
}
