// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subdivide/model/generate.dart';
import 'package:subdivide/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = [out, generateShapeData];

ShapeData getShapeData(BuildContext context, {required bool listen}) =>
    getShapeNotifier(context, listen: listen).shapeData;

ShapeNotifier getShapeNotifier(BuildContext context, {required bool listen}) =>
    Provider.of<ShapeNotifier>(context, listen: listen);

/// Access to the [ShapeData].
/// Generated in generate.dart, drawn by [Shape].
class ShapeNotifier extends ChangeNotifier {
  late ShapeData _shapeData;

  ShapeData get shapeData => _shapeData;

  //TODO remove HACK for quick hot reaload
  // ShapeData get shapeData => generateShapeData();

  void init(ShapeData shapeData_) {
    _shapeData = shapeData_;
  }
}

/// All the persisted data needed to render a 3d shape (football)
class ShapeData {
  const ShapeData({
    required this.vertices,
    required this.seamVertices,
    required this.meshes,
  });

  final List<Vector3> vertices;
  final List<Vector3> seamVertices;

  final List<Mesh> meshes;

  ShapeData.fromString(String json) : this.fromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(this);

  ShapeData.fromJson(Map<String, dynamic> json)
      : vertices = json['vertices']
            .map<Vector3>(
              (v) => Vertex.fromJson(v),
            )
            .toList(),
        seamVertices = json['vertices']
            .map<Vector3>(
              (v) => Vertex.fromJson(v),
            )
            .toList(),
        meshes = json['meshes']
            .map<Mesh>(
              (m) => Mesh.fromJson(m),
            )
            .toList();

  Map<String, dynamic> toJson() => {
        'vertices': vertices.map((v) => Vertex(v)).toList(),
        'seamVertices': seamVertices.map((v) => Vertex(v)).toList(),
        'meshes': meshes
            .map(
              (m) => m.toJson(),
            )
            .toList(),
      };
}

class Mesh {
  const Mesh({
    required this.faces,
    required this.isDark,
  });

  final List<Face> faces;

  final bool isDark;

  Mesh.fromString(String json) : this.fromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(this);

  Mesh.fromJson(Map<String, dynamic> json)
      : faces = json['faces']
            .map<Face>(
              (f) => Face.fromJson(f),
            )
            .toList(),
        isDark = json.containsKey('isDark') ? json['isDark'] : false;

  Map<String, dynamic> toJson() => {
        'faces': faces,
        'isDark': isDark,
      };
}

//TODO maybe use this class from json + const constructor
class Vertex {
  Vertex(Vector3 v)
      : x = v.x,
        y = v.y,
        z = v.z;

  final double x, y, z;

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z};

  static Vector3 fromJson(Map<String, dynamic> json) =>
      Vector3(json['x'], json['y'], json['z']);
}

class Face {
  const Face(
    this.a,
    this.b,
    this.c, {
    this.aSeam = false,
    this.bSeam = false,
    this.cSeam = false,
  });

  final int a, b, c;
  final bool aSeam, bSeam, cSeam;

  Face.fromJson(Map<String, dynamic> json)
      : a = json['a'],
        b = json['b'],
        c = json['c'],
        aSeam = json['aSeam'],
        bSeam = json['bSeam'],
        cSeam = json['cSeam'];

  Map<String, dynamic> toJson() => {
        'a': a,
        'b': b,
        'c': c,
        'aSeam': aSeam,
        'bSeam': bSeam,
        'cSeam': cSeam,
      };
}
