// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/shape_data.dart';
import 'package:terrain/out.dart';
import 'package:vector_math/vector_math_64.dart';

const noWarn = out;

void setTransform(Matrix4 transform, BuildContext context) =>
    getVertexNotifier(context, listen: false).setTransform(transform, context);

VertexNotifier getVertexNotifier(BuildContext context,
        {required bool listen}) =>
    Provider.of<VertexNotifier>(context, listen: listen);

class VertexNotifier extends ChangeNotifier {
  late List<Vector3> vertices;

  void setTransform(Matrix4 transform, BuildContext context) {
    final shapeData = getShapeData(context, listen: false);

    for (int i = 0; i < shapeData.vertices.length; ++i) {
      vertices[i] = transform.transformed3(shapeData.vertices[i], vertices[i]);
    }

    notifyListeners();
  }

  void init(List<Vector3> list) {
    vertices = list;
  }
}
