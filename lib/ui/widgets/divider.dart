import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key, this.color = Colors.grey, this.thickness = 1.5,});
  final Color color;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color.withOpacity(0.4),
      thickness: thickness,
    );
  }
}
