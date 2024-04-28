import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class Pickers {
  Pickers._();

  static Future<DateTimeRange?> pickDateRange(BuildContext context) async {
    return await showDateRangePicker(
      context: context,
      initialDateRange: null,
      firstDate: DateTime(2022),
      lastDate: DateTime(2024),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              brightness: Brightness.light,
              primary: AppColors.primaryLighter,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
