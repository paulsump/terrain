// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:convert';
import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:terrain/model/shape_data.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = [out, Vector3];

void main() {
  //TODO ShapeData persistence tests
  group('ShapeData json empty', () {
    const testJson = '{"meshes": [],"faces": []}';

    test('load', () {
      Map<String, dynamic> map = jsonDecode(testJson);
      ShapeData newShapeData = ShapeData.fromJson(map);

      expect(newShapeData.meshes.length, equals(0));
    });

    test('load toString()', () {
      ShapeData newShapeData = ShapeData.fromString(testJson);
      expect(newShapeData.meshes.length, equals(0));
    });
  });

  group('ShapeData json one face', () {
    // final meshes = <Vector3>[Vector3(1, 2, 3)];

    // final testShapeData = ShapeData(meshes: meshes);
    const testJson =
        '{"meshes":[{"vertices":[{"x":1.0,"y":2.0,"z":3.0}],"faces":[{"a":4,"b":5,"c":6}]}]}';

    test('load fromString()', () {
      ShapeData newShapeData = ShapeData.fromString(testJson);
      expect(newShapeData.meshes.length, equals(1));
    });
  });
}
