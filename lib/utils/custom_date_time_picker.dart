import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class CustomDateTimePicker {
  static Future<String> displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: ThemeData.light().copyWith(
              canvasColor: Colors.transparent,
            ),
            child: child!,
          ),
        );
      },
    );

    if (time != null) {
      return changeTimeFormat(time);
    } else {
      return '';
    }
    /*var time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      return changeTimeFormat(time);
    } else {
      return '';
    }*/
  }

  static Future<String> selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            canvasColor: Colors.transparent,
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      return changeDateFormat(selectedDate);
    } else {
      return '';
    }
    /*final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      return changeDateFormat(picked);
    } else {
      return '';
    }*/
  }

  static Future<String> selectMonthYear(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showMonthYearPicker(
        context: context,
        initialDate: DateTime(now.year, now.month, now.day),
        firstDate: DateTime(now.year, now.month, now.day),
        lastDate: DateTime(2101),
        selectableMonthYearPredicate: (DateTime val) {
          return !dateComparision([], val);
        });
    if (picked != null) {
      return changeDateFormat(picked);
    } else {
      return '';
    }
  }

  static bool areSameDay(DateTime one, DateTime two) {
    return one.day == two.day && one.month == two.month && one.year == two.year;
  }

  static bool dateComparision(List<DateTime> dates, DateTime targetDate) {
    try {
      dates.firstWhere((date) => areSameDay(date, targetDate));
      return true;
    } catch (_) {
      return false;
    }
  }

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(DateTime.parse(
          DateFormat("yyyy-MM-dd").format(startDate.add(Duration(days: i)))));
    }
    return days;
  }

  static String get24HoursTime(DateTime date) {
    return DateFormat('HH:mm:ss').format(date);
  }

  static String get12HoursTime(DateTime date) {
    return DateFormat("h:mma").format(date);
  }

  static bool reservedDateExistInRange(
      List<DateTime> unAvailableDates, List<DateTime> selectedRange) {
    return unAvailableDates
        .toSet()
        .intersection(selectedRange.toSet())
        .isNotEmpty;
  }

  static String changeDateFormat(DateTime date) {
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(date);
    debugPrint(formatted); // something like 2013-04-20
    return formatted;
  }

  static String changeTimeFormat(TimeOfDay time) {
    DateTime now = DateTime.now();
    DateTime dt =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final DateFormat formatter = DateFormat('hh:mm a');
    final String formatted = formatter.format(dt);
    debugPrint(formatted); // something like 2013-04-20
    return formatted;
  }

  static DateTime changeDateForComparison(DateTime inputDate) {
    return DateTime.parse(
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.000z").format(inputDate));
  }

  static Duration calculateRemainingTime(
      DateTime createdTime, Duration validityDuration) {
    DateTime currentTime =
        DateTime.now().toUtc(); // Convert current time to UTC
    Duration elapsedTime = currentTime.difference(createdTime
        .toUtc()); // Convert created time to UTC before calculating difference
    Duration remainingTime =
        validityDuration - elapsedTime; // Include time difference
    return remainingTime > validityDuration ? validityDuration : remainingTime;
  }
}

String changeDateTimeFormat(DateTime inputDateTime, String format) {
  return DateFormat(format).format(inputDateTime);
}
String changeTimeFormat(String inputDateTime , String format) {
  DateTime dateTime = DateFormat('HH:mm:ss').parse(inputDateTime);
  return DateFormat(format)
      .format(dateTime);
}
String changeDateFormat(String inputDate) {
  return DateFormat("yyyy-MM-dd'T'00:00:00.000")
      .format(DateFormat('dd/MM/yyyy').parse(inputDate));
}

String convertTimeFormat(String inputTime) =>
    DateFormat("HH:mm:ss").format(DateFormat("hh:mm a").parse(inputTime));
