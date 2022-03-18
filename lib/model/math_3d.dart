// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:core';

import 'package:vector_math/vector_math_64.dart';

/// Static helper functions
/// See the test file.
class Math3d {
  /// face normal from three vertices on the plane.
  /// (usually the corners of a triangle)
  /// The result is not normalised.
  static Vector3 normal(Vector3 a, Vector3 b, Vector3 c) {
    // TODO change the direction of these

    final Vector3 bVector = b - a;
    final Vector3 cVector = c - a;

    return bVector.cross(cVector);
  }

  /// Scale the distance of a vector from a central point
  /// i.e. move it closer or further away from 'origin'
  static Vector3 scaleFrom(
    double scale,
    Vector3 vertex_,
    Vector3 origin,
  ) {
    var vertex = Vector3.copy(vertex_);
    vertex -= origin;
    vertex *= scale;
    vertex += origin;
    return vertex;
  }
}
