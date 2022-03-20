// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';
import 'dart:math';

import 'package:terrain/model/math_3d.dart';
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
  final generator = MeshGenerator(222);

  final mesh = generator.getMesh();
  _rotateX(75, mesh);

  return mesh;
}

/// generate a triangle strip mesh
class MeshGenerator {
  /// n = num quads in both x and y
  MeshGenerator(int n) {
    _calcVerticesAndIndices(n);

    _setHeights();
    _calcVertexNormals(calcFaceNormals());
  }

  final vertices = <Vector3>[];
  final normals = <Vector3>[];

  final indices = <int>[];

  void _setHeights() {
    for (final vertex in vertices) {
      vertex.z = 0.05 * (sin(2 * pi * vertex.x) + sin(2 * pi * vertex.y));
    }
  }

  List<Vector3> calcFaceNormals() {
    final faceNormals = <Vector3>[];

    for (int i = 0; i < indices.length; i += 3) {
      v(index) => vertices[indices[index]];

      faceNormals.add(Math3d.normal(v(i), v(i + 1), v(i + 2)));
    }

    return faceNormals;
  }

  void _calcVertexNormals(List<Vector3> faceNormals) {
    //TODO
  }

  // see sketches/grid.png
  void _calcVerticesAndIndices(int n) {
    for (int x = 0; x <= n; ++x) {
      for (int y = 0; y <= n; ++y) {
        vertices.add(Vector3(x / n, y / n, 0));

        if (x != n && y != n) {
          final N = n + 1;

          final x0 = N * x;
          final x1 = N * (x + 1);

          final y0 = y;
          final y1 = y + 1;

          // a b
          // c d

          final a = x0 + y1;
          final b = x1 + y1;

          final c = x0 + y0;
          final d = x1 + y0;

          indices.add(d);
          indices.add(a);
          indices.add(c);

          indices.add(a);
          indices.add(d);
          indices.add(b);
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
