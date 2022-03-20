// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:terrain/model/generate.dart';
import 'package:terrain/out.dart';

const noWarn = out;

void main() {
  group('MeshGenerator Constructor', () {
    test('n = 2', () {
      final meshGenerator = MeshGenerator(2);

      final expected = [
        [0.0, 0.0],
        [0.0, 0.5],
        [0.0, 1.0],
        [0.5, 0.0],
        [0.5, 0.5],
        [0.5, 1.0],
        [1.0, 0.0],
        [1.0, 0.5],
        [1.0, 1.0]
      ];
      for (int i = 0; i < meshGenerator.vertices.length; ++i) {
        expect(meshGenerator.vertices[i].x, equals(expected[i][0]));
        expect(meshGenerator.vertices[i].y, equals(expected[i][1]));
      }
      // [3, 1, 0, 1, 3, 4, 4, 2, 1, 2, 4, 5, 6, 4, 3, 4, 6, 7, 7, 5, 4, 5, 7, 8]
    });
  });
}
