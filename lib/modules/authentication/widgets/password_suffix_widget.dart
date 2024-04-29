import 'package:flutter/material.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

import '../../../../constants/constants.dart';

class PasswordSuffixIcon extends StatelessWidget {
  const PasswordSuffixIcon({Key? key, required this.isPasswordVisible, required this.onTap, this.iconSize = 20}) : super(key: key);
  final bool isPasswordVisible;
  final VoidCallback onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 20,
      icon: Icon(
        isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color:context.colorScheme.primary,
        size: iconSize,
      ),
    );
  }
}