import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class Styles {
  static LinearGradient linearGradient =  const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryRed, AppColors.primaryRed],
  );

  static const List<Color> blueButtonGradientColors = [
    Color(0xff1D71B8),
    Color(0xff003A6B),
  ];
  static const List<Color> redButtonGradientColors = [
    Color(0xffFF0000),
    Color(0xff520000),
  ];

  static final mapsSearchFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none
  );
}
