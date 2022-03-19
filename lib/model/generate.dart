// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:terrain/model/mesh.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

final noWarn = [out];

/// See README.md
/// This function is the interface to this file
Mesh generateMesh() => generateTriangleStripMesh(2);

Mesh generateTriangleStripMesh(int n) {
  final vertices = <Vector3>[];

  for (int i = 0; i < n; ++i) {
    final y = i.toDouble();

    vertices.add(Vector3(0, y, 0));
    vertices.add(Vector3(1, y, 0));
  }
  // final vertices= [
  //    Vector3(0, 0, 0),
  //    Vector3(1, 0, 0),
  //    Vector3(0, 1, 0),
  //    Vector3(1, 1, 0),
  //  ];

  return Mesh(
    vertices: vertices,
    normals: List<Vector3>.generate(vertices.length, (i) => Vector3(0, 0, 1)),
  );
}
