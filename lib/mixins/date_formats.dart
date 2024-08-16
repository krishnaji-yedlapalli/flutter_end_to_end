import 'package:flutter/material.dart';

mixin DateFormats {
  String get currentDateInFormatted {
    DateTime now = DateTime.now();

    String formattedDate = "${now.year}_${now.month}_${now.day}";
    return formattedDate;
  }

  String formatDateToDDMMYY(DateTime date) {
    String formattedDate = "${date.day}-${date.month}-${date.year}";
    return formattedDate;
  }

  DateTime mergeDateTimeAndTimeOfDay(DateTime dateTime, TimeOfDay timeOfDay) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  (DateTime, TimeOfDay) getDateFromMillisecondsSinceEpoch(
      int millisecondsSinceEpoch) {
    // Convert millisecondsSinceEpoch to DateTime
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

    // Extract time from DateTime to create a TimeOfDay
    TimeOfDay timeOfDay =
        TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    return (dateTime, timeOfDay);
  }

  bool compareDatesWithoutTime(DateTime date1, DateTime date2) {
    DateTime dateOnly1 = DateTime(date1.year, date1.month, date1.day);
    DateTime dateOnly2 = DateTime(date2.year, date2.month, date2.day);
    return dateOnly1.compareTo(dateOnly2) == 0;
  }

  int daysBetweenTwoDates(DateTime date1, DateTime date2) {
    DateTime dateOnly1 = DateTime(date1.year, date1.month, date1.day);
    DateTime dateOnly2 = DateTime(date2.year, date2.month, date2.day);

    Duration difference = dateOnly2.difference(dateOnly1);

    return difference.inDays.abs();
  }
}
