import 'package:flutter/material.dart';
import 'package:xstock/utils/extensions/extended_context.dart';

import '../../constants/app_colors.dart';

class LocationWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double rightMargin;
  const LocationWidget({super.key,
     required this.text,
  required this.onTap,
    this.rightMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        margin: EdgeInsets.only(right: rightMargin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.primary.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
             Icon(
              Icons.location_on,
              color: context.colorScheme.primary,

            ),
            Text(
              text,
              style:  TextStyle(color: context.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
