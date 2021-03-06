// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/gestures/pan_zoom.dart';
import 'package:terrain/gestures/rotator.dart';
import 'package:terrain/model/generate.dart';
import 'package:terrain/model/mesh.dart';
import 'package:terrain/out.dart';
import 'package:terrain/view/hue.dart';
import 'package:terrain/view/main_page.dart';
import 'package:terrain/view/screen_adjust.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = [out, unawaited];

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
        ChangeNotifierProvider(create: (_) => RotationNotifier()),
        ChangeNotifierProvider(create: (_) => ShapeNotifier()),
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

                final mesh = generateMesh();
                shapeNotifier.init(mesh);

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
