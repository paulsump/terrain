// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:subdivide/gestures/gesture_handler.dart';
import 'package:subdivide/gestures/pan_zoom.dart';

/// Handle gestures, passing them to [PanZoomer].
///
/// Stateful because of mutable fields.
class Gesturer extends StatefulWidget {
  const Gesturer({Key? key}) : super(key: key);

  @override
  State<Gesturer> createState() => GesturerState();
}

class GesturerState extends State<Gesturer> {
  final GestureHandler panZoomer = PanZoomer();

  late GestureHandler gestureHandler;

  bool tapped = false;
  Offset tapPoint = Offset.zero;

  int n = 0;
  double totalScale = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (details) {
        n = 0;
        totalScale = 0;

        gestureHandler = panZoomer;
        panZoomer.start(details.focalPoint, context);
      },
      onScaleUpdate: (details) {
        n++;

        totalScale += details.scale;

        gestureHandler.update(details.focalPoint, details.scale, context);
      },
      onScaleEnd: (details) {
        tapped = false;
        gestureHandler.end(context);
      },
      onTapDown: (details) {
        tapped = true;

        gestureHandler = panZoomer;
        tapPoint = details.localPosition;
      },
      onTapUp: (details) {
        tapped = false;

        gestureHandler.tapUp(details.localPosition, context);
      },
    );
  }
}
