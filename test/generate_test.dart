// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter_test/flutter_test.dart';
import 'package:terrain/model/generate.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = out;

void main() {
  group('Constructor', () {
    final meshGenerator = MeshGenerator(2);

    test('vertices n = 2', () {
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
    });

    test('indices n = 2', () {
      final expected = [
        3,
        1,
        0,
        1,
        3,
        4,
        4,
        2,
        1,
        2,
        4,
        5,
        6,
        4,
        3,
        4,
        6,
        7,
        7,
        5,
        4,
        5,
        7,
        8
      ];

      for (int i = 0; i < meshGenerator.indices.length; ++i) {
        expect(meshGenerator.indices[i], equals(expected[i]));
      }
    });
  });

  group('Normals n = 2', () {
    final meshGenerator = MeshGenerator(2);

    // add a little peak at the middle vertex
    meshGenerator.vertices[4].z = 1;

    final faceNormals = meshGenerator.calcFaceNormals();

    test('faceNormals', () {
      final expected = [
        Vector3(0.0, 0.0, 0.25),
        Vector3(-0.5, -0.5, 0.25),
        Vector3(-0.5, 0.0, 0.25),
        Vector3(0.0, 0.5, 0.25),
        Vector3(0.0, -0.5, 0.25),
        Vector3(0.5, 0.0, 0.25),
        Vector3(0.5, 0.5, 0.25),
        Vector3(0.0, 0.0, 0.25),
      ];

      for (int i = 0; i < faceNormals.length; ++i) {
        expect(faceNormals[i], equals(expected[i]));
      }
    });

    test('vertexNormals', () {
      meshGenerator.calcVertexNormals(faceNormals);

      final expected = [];

      final normals = meshGenerator.normals;
      out(normals);

      // for (int i = 0; i < normals.length; ++i) {
      //   expect(normals[i], equals(expected[i]));
      // }
    });
  });
}
