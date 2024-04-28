import 'package:flutter/material.dart';
import 'package:xstock/utils/utils.dart';

class RetryWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String errorMessage;
  const RetryWidget({super.key, required this.onTap, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(errorMessage),
          IconButton(onPressed: onTap, icon: Icon(Icons.refresh, color: context.colorScheme.primary, size: 30,))
        ],
      ),
    );
  }
}