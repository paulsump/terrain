// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:terrain/model/mesh.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

final noWarn = [out];

/// See README.md
/// This function is the interface to this file
Mesh generateMesh() {
  final mesh = generateTriangleStripMesh(9);
  _rotateX(75, mesh);

  return mesh;
}

Mesh generateTriangleStripMesh(int n) {
  final vertices = <Vector3>[];

  final step = 1 / n;

  for (int X = 0; X < n; ++X) {
    for (int Y = 0; Y <= n; ++Y) {
      final x = X * step;
      final y = Y * step;

      vertices.add(Vector3(x, y, 0));
      vertices.add(Vector3(x + step, y, 0));
    }
  }

  return Mesh(
    vertices: vertices,
    normals: List<Vector3>.generate(vertices.length, (i) => Vector3(0, 0, 1)),
  );
}

void _rotateX(double degrees, Mesh mesh) {
  final transform = Matrix4.rotationX(radians(degrees));

  final vertices = mesh.vertices;
  for (int i = 0; i < vertices.length; ++i) {
    transform.transform3(vertices[i]);
  }

  final normals = mesh.normals;
  for (int i = 0; i < normals.length; ++i) {
    transform.transform3(normals[i]);
  }
}