// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subdivide/gestures/pan_zoom.dart';
import 'package:subdivide/model/generate.dart';
import 'package:subdivide/model/persist.dart';
import 'package:subdivide/model/shape_data.dart';
import 'package:subdivide/out.dart';
import 'package:subdivide/view/hue.dart';
import 'package:subdivide/view/main_page.dart';
import 'package:subdivide/view/screen_adjust.dart';
import 'package:subdivide/view/vertex_notifier.dart';
import 'package:vector_math/vector_math_64.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [out, unawaited, loadShapeData];

void main() => runApp(createApp());

Widget createApp() => const TheApp();

/// The only App in this app.
class TheApp extends StatelessWidget {
  const TheApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PanZoomNotifier()),
        ChangeNotifierProvider(create: (_) => ShapeNotifier()),
        ChangeNotifierProvider(create: (_) => VertexNotifier()),
      ],
      child: MaterialApp(
        theme: _buildThemeData(context),
        home: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxHeight == 0) {
              return Container();
            } else {
              final panZoomNotifier =
                  getPanZoomNotifier(context, listen: false);

              // Initialize once only
              if (panZoomNotifier.scale == 0) {
                panZoomNotifier.initializeScale(screenAdjust(0.7, context));

                final shapeNotifier = getShapeNotifier(context, listen: false);

                final shapeData = generateShapeData();
                shapeNotifier.init(shapeData);

                final vertexNotifier =
                    getVertexNotifier(context, listen: false);

                vertexNotifier.init(
                    shapeData.vertices
                        .map((vertex) => Vector3.copy(vertex))
                        .toList(),
                    shapeData.seamVertices
                        .map((vertex) => Vector3.copy(vertex))
                        .toList());
              }
              // final
              return WillPopScope(
                onWillPop: () async => false,
                child: const MainPage(),
              );
            }
          },
        ),
      ),
    );
  }

  ThemeData _buildThemeData(BuildContext context) {
    return ThemeData(
      canvasColor: Hue.menu,
      textTheme: Theme.of(context).textTheme.apply(bodyColor: Hue.text),
      // for icon buttons only atm
      iconTheme: Theme.of(context).iconTheme.copyWith(
            color: Hue.enabledIcon,
          ),
      tooltipTheme: TooltipThemeData(
        /// TODO Responsive to screen size - removed magic numbers
        verticalOffset: 55,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Hue.tip),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: Hue.button,
      )),
    );
  }
}
