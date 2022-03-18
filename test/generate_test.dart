// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:subdivide/model/math_3d.dart';
import 'package:subdivide/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = out;

void main() {
  //TODO generate tests
  group('pentagon', () {
    test('top', () {
      // todo
      final xAxis = Vector3(1, 0, 0);

      final yAxis = Vector3(0, 1, 0);
      final zAxis = Vector3(0, 0, 1);

      final normal = Math3d.normal(xAxis, yAxis, zAxis);

      final expected = Vector3(1, 1, 1);
      expect(normal, equals(expected));
    });
  });
}
