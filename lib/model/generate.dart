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

  // void _perturbHeights() {}
  // void _calcFaceNormals() {}
  // void _calcVertexNormals() {}

// n = num quads
  MeshBuilder(int n) {
    final step = 1 / n;

    for (int X = 0; X <= n; ++X) {
      for (int Y = 0; Y <= n; ++Y) {
        final x = X * step;
        final y = Y * step;

        vertices.add(Vector3(x, y, 0));
        if (X != n && Y != n) {
          final N = n + 1;

          final leftDiagonal = Y + 1 + X * N;
          final rightDiagonal = X * N + N + Y;

          indices.add(rightDiagonal);
          indices.add(leftDiagonal);
          indices.add(X * N + Y);

          indices.add(leftDiagonal);
          indices.add(rightDiagonal);
          indices.add(X * N + 1 + N + Y);
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
