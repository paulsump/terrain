// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/generate.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = [out, generateShapeData];

ShapeData getShapeData(BuildContext context, {required bool listen}) =>
    getShapeNotifier(context, listen: listen).shapeData;

ShapeNotifier getShapeNotifier(
  BuildContext context, {
  required bool listen,
}) =>
    Provider.of<ShapeNotifier>(context, listen: listen);

/// Access to the [ShapeData].
/// Generated in generate.dart, drawn by [Shape].
class ShapeNotifier extends ChangeNotifier {
  // late ShapeData _shapeData;
  //
  // ShapeData get shapeData => _shapeData;

  //TODO remove HACK for quick hot reload
  ShapeData get shapeData => generateShapeData();

  void init(ShapeData shapeData_) {
    // _shapeData = shapeData_;
  }
}

/// All the persisted data needed to render a 3d shape (football)
class ShapeData {
  const ShapeData({
    required this.vertices,
    required this.normals,
    required this.meshes,
  });

  final List<Vector3> vertices;
  final List<Vector3> normals;
  final List<Mesh> meshes;
}

class Mesh {
  const Mesh({
    required this.faces,
  });

  final List<Face> faces;
}

class Face {
  const Face(this.a, this.b, this.c);

  final int a, b, c;
}
