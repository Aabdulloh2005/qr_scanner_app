import 'package:flutter/material.dart';

extension StrinExtension on String {
  String toUpper() {
    return replaceRange(0, 1, characters.first.toUpperCase());
  }
}
