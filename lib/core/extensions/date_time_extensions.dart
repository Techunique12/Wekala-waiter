import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get _languageCode {
    return Get.locale?.languageCode ?? 'en';
  }

  /// 18/08/2026
  String get formatDisplayDate {
    final formatted = DateFormat('dd/MM/yyyy').format(this);
    return _languageCode == 'ar' ? _toArabicNumbers(formatted) : formatted;
  }

  /// 2026-08-18
  String get formatApiDate {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Tuesday 18 Aug 2026 • 11:30 PM
  String get formatDate {
    final formatted = DateFormat(
      'EEEE dd MMM yyyy • hh:mm a',
      _languageCode,
    ).format(this);

    return _languageCode == 'ar' ? _toArabicNumbers(formatted) : formatted;
  }

  /// Tuesday
  String get formatDay {
    return DateFormat('EEEE', _languageCode).format(this);
  }

  String get greetingKey {
    final hour = this.hour;

    if (hour < 12) {
      return 'good_morning';
    }

    if (hour < 18) {
      return 'good_afternoon';
    }

    return 'good_evening';
  }

  String _toArabicNumbers(String value) {
    const english = '0123456789';
    const arabic = '٠١٢٣٤٥٦٧٨٩';

    return value.split('').map((char) {
      final index = english.indexOf(char);
      return index == -1 ? char : arabic[index];
    }).join();
  }
}

extension TimeOfDayExtension on TimeOfDay {
  /// 11:30 PM
  String formatDisplayTime(BuildContext context) {
    return format(context);
  }

  /// 23:30
  String get formatApiTime {
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }
}

/// Convert API time `HH:mm` to TimeOfDay
TimeOfDay? parseApiTime(String value) {
  final parts = value.split(':');

  if (parts.length < 2) {
    return null;
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);

  if (hour == null || minute == null) {
    return null;
  }

  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    return null;
  }

  return TimeOfDay(hour: hour, minute: minute);
}
