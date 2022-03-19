// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:terrain/model/generate.dart';
import 'package:terrain/out.dart';

const noWarn = out;

void main() {
  group('pentagon', () {
    test('top', () {
      final mesh = generateTriangleStripMesh(4);
      out(mesh);
      // expect(normal, equals(expected));
    });
  });
}
