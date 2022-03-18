// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:terrain/model/shape_data.dart';
import 'package:terrain/out.dart';

const noWarn = out;

/// Create a shape from json in the 'shapes' assets folder
Future<ShapeData> loadShapeData() async {
  final assetStrings = await _Assets._getStrings('shapes/test');

  return ShapeData.fromString(assetStrings['test.json']!);
}

/// for loading asset files
class _Assets {
  /// return map of filename + loaded string
  static Future<Map<String, String>> _getStrings(String pathStartsWith) async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');

    final filePaths = <String, String>{};

    for (final String filePath in jsonDecode(manifestJson).keys) {
      if (filePath.startsWith(pathStartsWith)) {
        final fileName = filePath.split('/').last;

        filePaths[fileName] = await rootBundle.loadString(filePath);
      }
    }
    return filePaths;
  }
}
