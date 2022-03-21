// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:terrain/gestures/gesture_handler.dart';
import 'package:terrain/out.dart';
import 'package:terrain/view/unit_to_screen.dart';

const noWarn = [out];

class Rotator implements GestureHandler {
  @override
  void start(Offset point, BuildContext context) {
    final Offset startUnit = screenToUnit(point, context);
  }

  @override
  void update(Offset point, double scale, BuildContext context) {}

  @override
  void end(BuildContext context) => _finish(context);

  @override
  void tapDown(Offset point, BuildContext context) {}

  @override
  void tapUp(Offset point, BuildContext context) => _finish(context);

  _finish(BuildContext context) {}
}
