// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = [out, Vector3];

void main() {
  //TODO ShapeData tests
  group('ShapeData empty', () {
    test('load', () {
      // expect(newShapeData.meshes.length, equals(0));
    });

    test('load toString()', () {});
  });
}
