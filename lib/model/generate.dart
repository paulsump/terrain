// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:terrain/model/shape_data.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

final noWarn = [out, _triangle, _subdivide];

/// See README.md
/// This function is the interface to this file
ShapeData generateShapeData() {
  ShapeData shapeData = _triangle;

  // shapeData = _subdivide(shapeData);

  return shapeData;
}

/// add vector and return it's index
int _getOrAdd(Vector3 vector3, List<Vector3> vertices) {
  int index = vertices.length;

  // TODO only add IF not found
  vertices.add(vector3);
  return index;
}

/// See triangle_subdivide.png
ShapeData _subdivide(ShapeData old) {
  final vertices = <Vector3>[...old.vertices];
  final normals = <Vector3>[...old.normals];

  final light = <Face>[];
  final mesh = Mesh(faces: light);

  final meshes = <Mesh>[mesh];

  for (final mesh in old.meshes) {
    final faces = mesh.faces;

    for (final face in mesh.faces) {
      final a = vertices[face.a];
      final b = vertices[face.b];
      final c = vertices[face.c];

      final an = normals[face.a];
      final bn = normals[face.b];
      final cn = normals[face.c];

      final p = (a + b) / 2;
      final q = (b + c) / 2;
      final r = (c + a) / 2;

      // TODO including surrounding normals into the average
      final pn = (an + bn) / 2;
      final qn = (bn + cn) / 2;
      final rn = (cn + an) / 2;

      final i = _getOrAdd(p, vertices);
      final j = _getOrAdd(q, vertices);
      final k = _getOrAdd(r, vertices);

      _getOrAdd(pn, normals);
      _getOrAdd(qn, normals);
      _getOrAdd(rn, normals);

      faces.add(Face(face.a, i, k));
      faces.add(Face(i, face.b, j));
      faces.add(Face(j, face.c, k));
      faces.add(Face(k, i, j));
    }
  }

  return ShapeData(vertices: vertices, normals: normals, meshes: meshes);
}

//TODO MAKe final
get _triangle => ShapeData(
      vertices: [
        Vector3(0, 0, 0),
        Vector3(1, 0, 0),
        Vector3(0, 1, 0),
      ],
      normals: [
        Vector3(0, 0, 1),
        Vector3(0, 0, 1),
        Vector3(0, 0, 1),
      ],
      meshes: <Mesh>[
        const Mesh(faces: [Face(0, 1, 2)])
      ],
    );
