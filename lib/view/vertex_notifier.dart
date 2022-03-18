// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terrain/model/mesh.dart';
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
  late List<Vector3> normals;

  void setTransform(Matrix4 transform, BuildContext context) {
    final mesh = getMesh(context, listen: false);

    final originalVertices = mesh.vertices;
    for (int i = 0; i < originalVertices.length; ++i) {
      vertices[i] = transform.transformed3(originalVertices[i], vertices[i]);
    }

    final originalNormals = mesh.normals;
    for (int i = 0; i < originalNormals.length; ++i) {
      normals[i] = transform.transformed3(originalNormals[i], normals[i]);
    }

    notifyListeners();
  }

  void init(List<Vector3> vertices_, List<Vector3> normals_) {
    vertices = vertices_;
    normals = normals_;
  }
}
