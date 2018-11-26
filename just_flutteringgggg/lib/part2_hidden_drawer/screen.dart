import 'package:flutter/material.dart';

class Screen {
  final String title;
  final DecorationImage decorationImage;
  final WidgetBuilder contentBuilder;

  Screen({
    this.title,
    this.decorationImage,
    this.contentBuilder,
  });
}
