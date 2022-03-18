// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:subdivide/model/math_3d.dart';
import 'package:subdivide/model/shape_data.dart';
import 'package:subdivide/out.dart';
import 'package:vector_math/vector_math_64.dart';

final noWarn = [_normalize, out, _triangle, _subdivide];

/// See README.md
/// This function is the interface to this file
ShapeData generateShapeData() {
  ShapeData shapeData = _icosahedron;

  shapeData = _subdivideFrequency3(shapeData);
  shapeData = _subdivide(shapeData);

  _normalize(shapeData.vertices);
  _normalize(shapeData.seamVertices);

  for (final vertex in shapeData.seamVertices) {
    vertex.scale(_seamDepth);
  }
  return shapeData;
}

const _seamDepth = 0.985;
const double _patchScale = 0.85;

/// for each vector coming out from a vertex
/// go a third of the way along and add that ver (do face the same time)
ShapeData _subdivideFrequency3(ShapeData old) {
  final vertices = <Vector3>[...old.vertices];
  final seamVertices = <Vector3>[];

  final darkMeshes = <Mesh>[];
  final lightMeshes = <Mesh>[];

  final darkSeamMeshes = <Mesh>[];
  final lightSeamMeshes = <Mesh>[];

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

    // copy vertices for the seam
    final int p1_ = _getOrAdd(vertices[p1], seamVertices);
    final int p2_ = _getOrAdd(vertices[p2], seamVertices);
    final int q1_ = _getOrAdd(vertices[q1], seamVertices);
    final int q2_ = _getOrAdd(vertices[q2], seamVertices);
    final int r1_ = _getOrAdd(vertices[r1], seamVertices);
    final int r2_ = _getOrAdd(vertices[r2], seamVertices);

    final lightSeam = <Face>[];
    lightSeamMeshes.add(Mesh(faces: lightSeam, isDark: false));

    // next to dark seams
    lightSeam.add(Face(r2, r2_, p1, bSeam: true));
    lightSeam.add(Face(r2_, p1_, p1, aSeam: true, bSeam: true));
    lightSeam.add(Face(p2, p2_, q1, bSeam: true));
    lightSeam.add(Face(p2_, q1_, q1, aSeam: true, bSeam: true));
    lightSeam.add(Face(r1, q2, q2_, cSeam: true));
    lightSeam.add(Face(r1, q2_, r1_, bSeam: true, cSeam: true));

    // next to light seams from another 9 triangles
    lightSeam.add(Face(p1, p1_, p2, bSeam: true));
    lightSeam.add(Face(p2, p1_, p2_, bSeam: true, cSeam: true));
    lightSeam.add(Face(q2, q1, q1_, cSeam: true));
    lightSeam.add(Face(q2, q1_, q2_, bSeam: true, cSeam: true));
    lightSeam.add(Face(r2, r1, r1_, cSeam: true));
    lightSeam.add(Face(r2, r1_, r2_, bSeam: true, cSeam: true));

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

    final darkSeam = <Face>[];
    darkSeamMeshes.add(Mesh(faces: darkSeam, isDark: true));

    darkSeam.add(Face(r2, p1, r2_, cSeam: true));
    darkSeam.add(Face(r2_, p1, p1_, aSeam: true, cSeam: true));
    darkSeam.add(Face(p2, q1, p2_, cSeam: true));
    darkSeam.add(Face(p2_, q1, q1_, aSeam: true, cSeam: true));
    darkSeam.add(Face(r1, q2_, q2, bSeam: true));
    darkSeam.add(Face(r1, r1_, q2_, cSeam: true, bSeam: true));
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
    seamVertices: seamVertices,
    meshes: <Mesh>[
      ...darkMeshes,
      ...lightMeshes,
      ...lightSeamMeshes,
      ...darkSeamMeshes
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
  final seamVertices = <Vector3>[...old.seamVertices];

  final dark = <Face>[];
  final light = <Face>[];

  final darkMesh = Mesh(faces: dark, isDark: true);
  final lightMesh = Mesh(faces: light, isDark: false);

  final meshes = <Mesh>[darkMesh, lightMesh];

  for (final mesh in old.meshes) {
    final faces = mesh.isDark ? darkMesh.faces : lightMesh.faces;

    for (final face in mesh.faces) {
      final bool aSeam = face.aSeam;
      final bool bSeam = face.bSeam;
      final bool cSeam = face.cSeam;

      final a = aSeam ? seamVertices[face.a] : vertices[face.a];
      final b = bSeam ? seamVertices[face.b] : vertices[face.b];
      final c = cSeam ? seamVertices[face.c] : vertices[face.c];

      final p = (a + b) / 2;
      final q = (b + c) / 2;
      final r = (c + a) / 2;

      final bool i2 = face.aSeam && face.bSeam;
      final bool j2 = face.bSeam && face.cSeam;
      final bool k2 = face.cSeam && face.aSeam;

      final i = _getOrAdd(p, i2 ? seamVertices : vertices);
      final j = _getOrAdd(q, j2 ? seamVertices : vertices);
      final k = _getOrAdd(r, k2 ? seamVertices : vertices);

      faces.add(Face(face.a, i, k, aSeam: aSeam, bSeam: i2, cSeam: k2));
      faces.add(Face(i, face.b, j, aSeam: i2, bSeam: bSeam, cSeam: j2));
      faces.add(Face(j, face.c, k, aSeam: j2, bSeam: cSeam, cSeam: k2));
      faces.add(Face(k, i, j, aSeam: k2, bSeam: i2, cSeam: j2));
    }
  }

  return ShapeData(
    vertices: vertices,
    seamVertices: seamVertices,
    meshes: meshes,
  );
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
const double cSeam = (root5 + 1) / 4;

const double s1 = 0.9510565162951535; //sqrt(10+2*root5)/4;
const double s2 = 0.5877852522924731; //sqrt(10-2*root5)/4;

final _icosahedron = ShapeData(vertices: <Vector3>[
  // north pole (z)
  Vector3(0, 0, root5 / 2),

  // top pentagon from top anticlockwise
  Vector3(0, 1, 0.5),
  Vector3(-s1, c1, 0.5),
  Vector3(-s2, -cSeam, 0.5),
  Vector3(s2, -cSeam, 0.5),
  Vector3(s1, c1, 0.5),

  // bottom pentagon from top anticlockwise
  Vector3(-s2, cSeam, -0.5),
  Vector3(-s1, -c1, -0.5),
  Vector3(0, -1, -0.5),
  Vector3(s1, -c1, -0.5),
  Vector3(s2, cSeam, -0.5),

  // south pole
  Vector3(0, 0, -root5 / 2),
], seamVertices: <Vector3>[], meshes: <Mesh>[
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
  seamVertices: <Vector3>[],
  meshes: <Mesh>[
    const Mesh(
      faces: [Face(0, 1, 2)],
      isDark: false,
    )
  ],
);
