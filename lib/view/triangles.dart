import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:terrain/out.dart';

const noWarn = out;

/// Draw a list o vertex shaded triangles.
class Triangles extends StatelessWidget {
  const Triangles({
    Key? key,
    required this.offsets,
    required this.colors,
  }) : super(key: key);

  final List<Offset> offsets;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(
        Vertices(
          VertexMode.triangleStrip,
          offsets,
          colors: colors,
        ),
      ),
    );
  }
}

/// The painter for [Triangles].
class _Painter extends CustomPainter {
  const _Painter(this.vertices);

  final Vertices vertices;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawVertices(vertices, BlendMode.srcOver, _redPaint);
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) => true;
}

final _redPaint = Paint()
  ..color = Colors.red
  ..style = PaintingStyle.stroke;
