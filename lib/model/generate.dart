// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:terrain/model/math_3d.dart';
import 'package:terrain/model/shape_data.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

final noWarn = [_normalize, out, _triangle, _subdivide];

/// See README.md
/// This function is the interface to this file
ShapeData generateShapeData() {
  ShapeData shapeData = _icosahedron;

  shapeData = _subdivideFrequency3(shapeData);
  shapeData = _subdivide(shapeData);

  _normalize(shapeData.vertices);
  return shapeData;
}

const double _patchScale = 0.85;

/// for each vector coming out from a vertex
/// go a third of the way along and add that ver (do face the same time)
ShapeData _subdivideFrequency3(ShapeData old) {
  final vertices = <Vector3>[...old.vertices];

  final darkMeshes = <Mesh>[];
  final lightMeshes = <Mesh>[];


  for (final face in old.meshes.first.faces) {
    // face corners
    final a = vertices[face.a];
    final b = vertices[face.b];
    final c = vertices[face.c];

    // edge vectors
    final p = b - a;
    final q = c - b;
    final r = a - c;

    final center = (a + b + c) / 3;
    final int s = _getOrAdd(center, vertices);

    // one third along edge
    int p1 = _getOrAdd(a + p * 1 / 3, vertices);
    int q1 = _getOrAdd(b + q * 1 / 3, vertices);
    int r1 = _getOrAdd(c + r * 1 / 3, vertices);

    // two thirds along edge
    int p2 = _getOrAdd(a + p * 2 / 3, vertices);
    int q2 = _getOrAdd(b + q * 2 / 3, vertices);
    int r2 = _getOrAdd(c + r * 2 / 3, vertices);

    // inner 6 are light
    final lightMesh = <Face>[];
    lightMeshes.add(Mesh(faces: lightMesh, isDark: false));

    lightMesh.add(Face(p1, s, r2));
    lightMesh.add(Face(p2, s, p1));
    lightMesh.add(Face(q1, s, p2));
    lightMesh.add(Face(q2, s, q1));
    lightMesh.add(Face(r1, s, q2));
    lightMesh.add(Face(r2, s, r1));


    final darkMesh = <Face>[];
    darkMeshes.add(Mesh(faces: darkMesh, isDark: true));

    // copy vertices for the dark pentagon
    p1 = _getOrAdd(vertices[p1], vertices);
    p2 = _getOrAdd(vertices[p2], vertices);
    q1 = _getOrAdd(vertices[q1], vertices);
    q2 = _getOrAdd(vertices[q2], vertices);
    r1 = _getOrAdd(vertices[r1], vertices);
    r2 = _getOrAdd(vertices[r2], vertices);

    // outer 3 are dark
    darkMesh.add(Face(face.a, p1, r2));
    darkMesh.add(Face(face.b, q1, p2));
    darkMesh.add(Face(face.c, r1, q2));

  }

  // scale the light hexagons
  for (final lightMesh in lightMeshes) {
    for (final face in lightMesh.faces) {
      final pqr = vertices[face.a];

      final s = vertices[face.b];
      vertices[face.a] = Math3d.scaleFrom(_patchScale, pqr, s);
    }
  }

  var total = Vector3(0, 0, 0);

  for (final darkMesh in darkMeshes) {
    // north pole
    if (darkMesh.faces[0].a == 0) {
      // p1
      total += vertices[darkMesh.faces[0].b];
    }
  }

  // the distance to midpoint at north pole
  final double darkLength = total.length / 5;

  // pull all the dark centers in to this mid point
  for (int i = 0; i < old.vertices.length; ++i) {
    vertices[i].normalize();
    vertices[i] *= darkLength;
  }

  // scale the dark pentagons
  for (final darkMesh in darkMeshes) {
    for (final face in darkMesh.faces) {
      final origin = vertices[face.a];

      vertices[face.b] =
          Math3d.scaleFrom(_patchScale, vertices[face.b], origin);
      vertices[face.c] =
          Math3d.scaleFrom(_patchScale, vertices[face.c], origin);
    }
  }

  return ShapeData(
    vertices: vertices,
    meshes: <Mesh>[
      ...darkMeshes,
      ...lightMeshes,
    ],
  );
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

  final dark = <Face>[];
  final light = <Face>[];

  final darkMesh = Mesh(faces: dark, isDark: true);
  final lightMesh = Mesh(faces: light, isDark: false);

  final meshes = <Mesh>[darkMesh, lightMesh];

  for (final mesh in old.meshes) {
    final faces = mesh.isDark ? darkMesh.faces : lightMesh.faces;

    for (final face in mesh.faces) {

      final a = vertices[face.a];
      final b = vertices[face.b];
      final c = vertices[face.c];

      final p = (a + b) / 2;
      final q = (b + c) / 2;
      final r = (c + a) / 2;

      final i = _getOrAdd(p, vertices);
      final j = _getOrAdd(q, vertices);
      final k = _getOrAdd(r, vertices);

      faces.add(Face(face.a, i, k));
      faces.add(Face(i, face.b, j));
      faces.add(Face(j, face.c, k));
      faces.add(Face(k, i, j));
    }
  }

  return ShapeData(
    vertices: vertices,
      meshes: meshes);
}

void _normalize(List<Vector3> vertices) {
  for (final vertex in vertices) {
    vertex.normalize();
  }
}

const root5 = 2.23606797749979;

// https://youtu.be/xMh_LtlOs_4?t=69
// https://mathworld.wolfram.com/RegularPentagon.html
// https://www.youtube.com/watch?v=xMh_LtlOs_4&ab_channel=MechanicalMachineDesign

const double c1 = (root5 - 1) / 4;
const double c2 = (root5 + 1) / 4;

const double s1 = 0.9510565162951535; //sqrt(10+2*root5)/4;
const double s2 = 0.5877852522924731; //sqrt(10-2*root5)/4;

final _icosahedron = ShapeData(vertices: <Vector3>[
  // north pole (z)
  Vector3(0, 0, root5 / 2),

  // top pentagon from top anticlockwise
  Vector3(0, 1, 0.5),
  Vector3(-s1, c1, 0.5),
  Vector3(-s2, -c2, 0.5),
  Vector3(s2, -c2, 0.5),
  Vector3(s1, c1, 0.5),

  // bottom pentagon from top anticlockwise
  Vector3(-s2, c2, -0.5),
  Vector3(-s1, -c1, -0.5),
  Vector3(0, -1, -0.5),
  Vector3(s1, -c1, -0.5),
  Vector3(s2, c2, -0.5),

  // south pole
  Vector3(0, 0, -root5 / 2),
], meshes: <Mesh>[
  const Mesh(
    faces: [
      // top
      Face(0, 1, 2),
      Face(0, 2, 3),
      Face(0, 3, 4),
      Face(0, 4, 5),
      Face(0, 5, 1),

      // bottom
      Face(11, 10, 9),
      Face(11, 9, 8),
      Face(11, 8, 7),
      Face(11, 7, 6),
      Face(11, 6, 10),

      // top between
      Face(1, 6, 2),
      Face(2, 7, 3),
      Face(3, 8, 4),
      Face(4, 9, 5),
      Face(5, 10, 1),

      // bottom between
      Face(6, 7, 2),
      Face(7, 8, 3),
      Face(8, 9, 4),
      Face(9, 10, 5),
      Face(10, 6, 1),
    ],
    isDark: false,
  )
]);

final _triangle = ShapeData(
  vertices: [
    Vector3(0, 0, 0),
    Vector3(1, 0, 0),
    Vector3(0, 1, 0),
  ],
  meshes: <Mesh>[
    const Mesh(
      faces: [Face(0, 1, 2)],
      isDark: false,
    )
  ],
);
