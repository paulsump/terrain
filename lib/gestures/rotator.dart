// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/gestures/gesture_handler.dart';
import 'package:terrain/out.dart';
import 'package:terrain/view/unit_to_screen.dart';

const noWarn = [out];

RotationNotifier getRotationNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<RotationNotifier>(context, listen: listen);

class RotationNotifier extends ChangeNotifier {
  double xDegrees = 0, yDegrees = 0;

  void setRotation(double x, double y) {
    xDegrees = x;
    yDegrees = y;
    notifyListeners();
  }
}

class Rotator implements GestureHandler {
  Offset startUnit = Offset.zero;
  double yStart = 0;

  @override
  void start(Offset point, BuildContext context) {
    startUnit = screenToUnit(point, context);

    final rotationNotifier = getRotationNotifier(context, listen: false);
    yStart = rotationNotifier.yDegrees;
  }

  @override
  void update(Offset point, double scale, BuildContext context) {
    final Offset unitPoint = screenToUnit(point, context);

    final rotationNotifier = getRotationNotifier(context, listen: false);
    final diff = unitPoint.dx - startUnit.dx;

    rotationNotifier.setRotation(0, 90 * diff);
  }

  @override
  void end(BuildContext context) => _finish(context);

  @override
  void tapDown(Offset point, BuildContext context) {}

  @override
  void tapUp(Offset point, BuildContext context) => _finish(context);

  _finish(BuildContext context) {}
}
