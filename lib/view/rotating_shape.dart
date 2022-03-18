// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:terrain/out.dart';
import 'package:terrain/view/shape.dart';
import 'package:terrain/view/unit_to_screen.dart';
import 'package:terrain/view/vertex_notifier.dart';

const noWarn = out;

class RotatingShape extends StatefulWidget {
  const RotatingShape({Key? key}) : super(key: key);

  @override
  _RotatingShapeState createState() => _RotatingShapeState();
}

class _RotatingShapeState extends State<RotatingShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get radiansY => _controller.value * pi * 2;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100000),
    )..addListener(() {
        setTransform(getTransform(), context);
      });

    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Matrix4 getTransform() {
    // const double _scale = 8;

    // var transform = Matrix4.translationValues(0, -2, 1);
    var transform = Matrix4.identity();
    // transform.scale(_scale, _scale);

    // transform.rotateX(radians(90));
    // transform.rotateX(radiansY);
    transform.rotateY(radiansY);
    // transform.rotateZ(radiansY);

    return transform;
  }

  @override
  Widget build(BuildContext context) {
    return const UnitToScreen(child: Shape());
  }
}
