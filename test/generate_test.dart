// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:terrain/model/generate.dart';
import 'package:terrain/out.dart';

const noWarn = out;

void main() {
  group('generateTriangleStripMesh', () {
    test('n = 4', () {
      // final mesh = generateTriangleStripMesh(1);
      final mesh = generateMesh();
      out(mesh);
      // expect(normal, equals(expected));
    });
  });
}
