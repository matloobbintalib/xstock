import 'package:flutter/material.dart';
import 'package:xstock/utils/utils.dart';


class AuthBottomWidget extends StatelessWidget {
  const AuthBottomWidget({
    required this.text,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  final String text;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1.5),
          child: Text(text),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              actionText,
              style: context.textTheme.titleSmall?.copyWith(
                color: Colors.blue[900],
              ),
            ),
          ),
        ),
      ],
    );
  }
}