// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const noWarn = log;

// const _out = log;
final _out = debugPrint; // for tests
/// log any type of object, using toString()
/// or special case for a couple of types like List<Offset>

void out(Object object) {
  if (object is List<Offset>) {
    _out('n = ${object.length}\nconst [');
    for (Offset offset in object) {
      _out('Offset(${offset.dx},${offset.dy}),');
    }
    _out(']');
  } else if (object is Offset) {
    _out('${object.dx},${object.dy}');
  } else {
    _out(object.toString());
  }
}

void clipError(String text) {
  out(text);
  //TODO append to error log
//TODO make a command that user can load the log and saveTolClip
  writeToClipboard(text);
}

void writeToClipboard(String text) =>
    Clipboard.setData(ClipboardData(text: text));
