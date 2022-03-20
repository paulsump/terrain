import 'dart:core';

import 'package:flutter/material.dart';
import 'package:terrain/model/mesh.dart';
import 'package:terrain/out.dart';
import 'package:terrain/view/triangles.dart';
import 'package:vector_math/vector_math_64.dart' as vec_math;

import 'triangles.dart';

const noWarn = [out];

/// The terrain widget
class Shape extends StatelessWidget {
  const Shape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mesh = getMesh(context, listen: true);

    final vertices = mesh.vertices;
    final normals = mesh.normals;

    final offsets = <Offset>[];
    final colors = <Color>[];

    const Color color = Colors.white60;
    for (int i = 0; i < vertices.length; ++i) {
      offsets.add(_flipY(vertices[i]));

      colors.add(_getColor(normals[i], color));
    }

    return Triangles(offsets: offsets, colors: colors, indices: mesh.indices);
  }
}

Color _getColor(vec_math.Vector3 normal, Color color) {
  final brightness = _calcBrightness(normal);

  return _calcColor(brightness, color);
}

double _calcBrightness(vec_math.Vector3 normal) {
  final light = vec_math.Vector3(0.0, 0.0, 1.0).normalized();

  return normal.normalized().dot(light).clamp(0.0, 1.0);
}

Color _calcColor(double brightness, Color color) {
  return Color.fromARGB(
    255,
    (brightness * color.red).toInt(),
    (brightness * color.green).toInt(),
    (brightness * color.blue).toInt(),
  );
}

Offset _flipY(vec_math.Vector3 v) => Offset(v.x, -v.y);
