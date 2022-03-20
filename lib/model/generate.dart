// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:terrain/model/mesh.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

final noWarn = [
  out,
  _rotateX,
];

/// See README.md
/// This function is the interface to this file
Mesh generateMesh() {
  final builder = MeshBuilder(3);
  final mesh = builder.getMesh();

  _rotateX(75, mesh);
  return mesh;
}

///generateTriangleStripMesh
class MeshBuilder {
  final vertices = <Vector3>[];

  final indices = <int>[];

  void _setHeights() {}

  void _calcFaceNormals() {}

  void _calcVertexNormals() {}

// n = num quads
  MeshBuilder(int n) {
    _calcVerticesAndIndices(n);

    _setHeights();

    _calcFaceNormals();
    _calcVertexNormals();
  }

  void _calcVerticesAndIndices(int n) {
    for (int x = 0; x <= n; ++x) {
      for (int y = 0; y <= n; ++y) {
        vertices.add(Vector3(x / n, y / n, 0));

        if (x != n && y != n) {
          final N = n + 1;

          final leftDiagonal = y + 1 + x * N;
          final rightDiagonal = x * N + N + y;

          indices.add(rightDiagonal);
          indices.add(leftDiagonal);
          indices.add(x * N + y);

          indices.add(leftDiagonal);
          indices.add(rightDiagonal);
          indices.add(x * N + 1 + N + y);
        }
      }
    }
  }

  Mesh getMesh() {
    return Mesh(
      vertices: vertices,
      normals: List<Vector3>.generate(
        vertices.length,
        (i) => Vector3(0, 0, 1),
      ),
      indices: indices,
    );
  }
}

void _rotateX(double degrees, Mesh mesh) {
  final transform = Matrix4.rotationX(radians(degrees));

  final vertices = mesh.vertices;
  for (int i = 0; i < vertices.length; ++i) {
    transform.transform3(vertices[i]);
    transform.transform3(mesh.normals[i]);
  }
}
