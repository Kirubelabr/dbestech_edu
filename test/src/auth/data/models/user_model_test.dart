import 'dart:convert';

import 'package:dbestech_edu/core/utils/typedefs.dart';
import 'package:dbestech_edu/src/auth/data/models/user_model.dart';
import 'package:dbestech_edu/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = LocalUserModel.empty();

  test('should be a subclass of [LocalUser]', () async {
    expect(tModel, isA<LocalUser>());
  });

  final tMap = jsonDecode(fixture('user.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [LocalUserModel] from the map', () {
      // act
      final result = LocalUserModel.fromMap(tMap);
      //assert
      expect(result, isA<LocalUserModel>());
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the model', () {
      // act
      final result = tModel.toMap();
      //assert
      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [LocalUserModel] with the updated values', () {
      // act
      final result = tModel.copyWith(uid: '22');
      // assert
      expect(result.uid, equals('22'));
    });
  });
}
