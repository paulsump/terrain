import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:terrain/model/math_3d.dart';
import 'package:terrain/model/shape_data.dart';
import 'package:terrain/out.dart';
import 'package:terrain/view/triangles.dart';
import 'package:terrain/view/vertex_notifier.dart';
import 'package:vector_math/vector_math_64.dart' as vec_math;

import 'triangles.dart';

const noWarn = [out];

get _light => vec_math.Vector3(0.0, 0.0, 1.0).normalized();

/// The football widget
class Shape extends StatelessWidget {
  const Shape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shapeData = getShapeData(context, listen: false);

    final vertexNotifier = getVertexNotifier(context, listen: true);

    final vertices = vertexNotifier.vertices;

    final offsets = <Offset>[];
    final colors = <Color>[];

    for (final mesh in shapeData.meshes) {
      final Color color = mesh.isDark ? Colors.blueGrey : Colors.white60;

      for (final face in mesh.faces) {
        final a = vertices[face.a];
        final b = vertices[face.b];
        final c = vertices[face.c];

        if (a.z > 0 || b.z > 0 || c.z > 0) {
          final normal = Math3d.normal(a, b, c).normalized();

          if (0 < normal.z) {
            offsets.addAll(<Offset>[_flipY(a), _flipY(b), _flipY(c)]);

            colors.addAll(<Color>[
              _getColor(a, color),
              _getColor(b, color),
              _getColor(c, color),
            ]);
          }
        }
      }
    }
    return Triangles(offsets: offsets, colors: colors);
  }
}

Color _getColor(
  vec_math.Vector3 vertex,
    Color color) {
  final brightness = _calcBrightness(vertex);

  return _calcColor(brightness, color);
}

double _calcBrightness(vec_math.Vector3 normal) =>
    normal.normalized().dot(_light).clamp(0.0, 1.0);

Color _calcColor(double brightness, Color color) {
  return Color.fromARGB(
    255,
    (brightness * color.red).toInt(),
    (brightness * color.green).toInt(),
    (brightness * color.blue).toInt(),
  );
}

Offset _flipY(vec_math.Vector3 v) => Offset(v.x, -v.y);
