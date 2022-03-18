// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:terrain/gestures/gesturer.dart';
import 'package:terrain/out.dart';
import 'package:terrain/view/horizon.dart';
import 'package:terrain/view/hue.dart';
import 'package:terrain/view/rotating_shape.dart';

const noWarn = [out];

/// The only page in this app.
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Hue.background,
        child: SafeArea(
          left: false,
          child: Stack(children: const [
            Horizon(),
            Gesturer(),
            RotatingShape(),
          ]),
        ),
      ),
    );
  }
}
