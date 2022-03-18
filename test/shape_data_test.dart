// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = [out, Vector3];

void main() {
  //TODO Mesh tests
  group('Mesh empty', () {
    test('load', () {
      // expect(newMesh.meshes.length, equals(0));
    });

    test('load toString()', () {});
  });
}
