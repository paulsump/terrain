import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:terrain/out.dart';

const noWarn = [out, _debugColor];

_debugColor(n) {
  final colors = <Color>[];
  for (int i = 0; i < n; ++i) {
    colors.add(i % 3 == 0
        ? Colors.blue
        : i.isEven
            ? Colors.green
            : Colors.red);
  }
  return colors;
}

/// Draw a list o vertex shaded triangles.
class Triangles extends StatelessWidget {
  const Triangles({
    Key? key,
    required this.offsets,
    required this.colors,
    required this.indices,
  }) : super(key: key);

  final List<Offset> offsets;
  final List<Color> colors;
  final List<int> indices;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(
        Vertices(
          VertexMode.triangleStrip,
          offsets,
          // colors: _debugColor(offsets.length),
          colors: colors,
          indices: indices,
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
