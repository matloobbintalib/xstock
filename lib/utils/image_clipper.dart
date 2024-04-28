import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageClipper extends CustomClipper<Path> {
  @override
  ui.Path getClip(ui.Size size) {
    Path path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height) //65& on left
      ..lineTo(0, size.height * 0.65)
      ..lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<ui.Path> oldClipper)=> false;
}

