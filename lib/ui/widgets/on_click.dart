import 'package:flutter/material.dart';

class OnClick extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const OnClick({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
