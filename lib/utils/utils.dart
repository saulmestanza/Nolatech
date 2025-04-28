import 'package:flutter/material.dart';

class Utils {
  DateTime timeOfDayToDateTime(TimeOfDay timeOfDay, {DateTime? date}) {
    final now = date ?? DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }
}
