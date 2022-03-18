// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/generate.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = [out, generateMesh];

Mesh getMesh(BuildContext context, {required bool listen}) =>
    getShapeNotifier(context, listen: listen).mesh;

ShapeNotifier getShapeNotifier(
  BuildContext context, {
  required bool listen,
}) =>
    Provider.of<ShapeNotifier>(context, listen: listen);

/// Access to the [Mesh].
/// Generated in generate.dart, drawn by [Shape].
class ShapeNotifier extends ChangeNotifier {
  // late Mesh _mesh;
  //
  // Mesh get mesh => _mesh;

  //TODO remove HACK for quick hot reload
  Mesh get mesh => generateMesh();

  void init(Mesh mesh_) {
    // _mesh = mesh_;
  }
}

/// A triangle mesh with vertex positions and normals and vertex indices
/// TODO MAybe replace Face list with indices list (contiguous groups of three indices).
/// All the persisted data needed to render a 3d shape (terrain)
class Mesh {
  const Mesh({
    required this.vertices,
    required this.normals,
    required this.faces,
  });

  final List<Vector3> vertices;
  final List<Vector3> normals;
  final List<Face> faces;
}

class Face {
  const Face(this.a, this.b, this.c);

  /// Vertex indices of a triangle.
  final int a, b, c;
}
