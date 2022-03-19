// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:terrain/model/mesh.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

final noWarn = [out, _triangle];

/// See README.md
/// This function is the interface to this file
Mesh generateMesh() {
  Mesh mesh = _triangle;

  return mesh;
}

//TODO MAKe final
get _triangle => Mesh(
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
      faces: <Face>[const Face(0, 1, 2)],
    );
