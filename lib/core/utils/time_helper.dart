import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeHelper {
  /// Formats a time string (expected HH:mm or HH:mm:ss) to 12-hour format with AM/PM.
  /// Example: "14:30" -> "02:30 PM"
  static String formatStringTime(String? time) {
    if (time == null || time.isEmpty) return '--:-- --';

    try {
      // If it contains AM/PM already, return it (but maybe clean it)
      if (time.toLowerCase().contains('am') ||
          time.toLowerCase().contains('pm')) {
        return time.toUpperCase();
      }

      // Parse HH:mm
      final parts = time.split(':');
      if (parts.length < 2) return time;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final dateTime = DateTime(2022, 1, 1, hour, minute);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return time;
    }
  }

  /// Formats a TimeOfDay object to 12-hour format with AM/PM.
  static String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '--:-- --';

    final dateTime = DateTime(2022, 1, 1, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dateTime);
  }
}
