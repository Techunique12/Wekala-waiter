import 'package:flutter/material.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class AppTheme {
  static ThemeData dark({Color color = const Color(0xFF3B1A63)}) => ThemeData(
    fontFamily: AppConstants.fontFamily,
    primaryColor: color,
    secondaryHeaderColor: const Color(0xFF009f67),
    disabledColor: const Color(0xffa2a7ad),
    brightness: Brightness.dark,
    hintColor: const Color(0xFFbebebe),
    cardColor: const Color(0xFF30313C),
    shadowColor: Colors.white.withValues(alpha: 0.03),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: color),
    ),
    colorScheme: ColorScheme.dark(
      primary: color,
      secondary: color,
    ).copyWith(error: const Color(0xFFdd3135)),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF29292D),
      surfaceTintColor: Color(0xFF29292D),
    ),
    dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      surfaceTintColor: Colors.black,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 5),
    ),
    tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: const Color(0xFF29292D),
      surfaceTintColor: Colors.transparent,

      headerBackgroundColor: color,
      headerForegroundColor: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      todayForegroundColor: WidgetStatePropertyAll(Colors.white),

      todayBorder: BorderSide(color: color),

      confirmButtonStyle: TextButton.styleFrom(foregroundColor: Colors.white),
      cancelButtonStyle: TextButton.styleFrom(foregroundColor: Colors.white),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: const Color(0xFF29292D),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      hourMinuteColor: color,
      hourMinuteTextColor: Colors.white,

      dayPeriodColor: color,
      dayPeriodTextColor: Colors.white,

      dialBackgroundColor: const Color(0xFF30313C),
      dialHandColor: color,
      dialTextColor: Colors.white,

      cancelButtonStyle: TextButton.styleFrom(foregroundColor: Colors.white),
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: Colors.white),
    ),
  );
  static ThemeData light({Color color = const Color(0xFF52238b)}) => ThemeData(
    fontFamily: AppConstants.fontFamily,
    primaryColor: color,
    secondaryHeaderColor: const Color(0xFF1ED7AA),
    disabledColor: const Color(0xFF9F9F9F),
    brightness: Brightness.light,
    hintColor: const Color(0xFF9F9F9F),
    cardColor: Colors.white,
    shadowColor: Colors.black.withValues(alpha: 0.03),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: color),
    ),
    colorScheme: ColorScheme.light(primary: color, secondary: color).copyWith(
      error: const Color(0xFFE84D4F),
      surfaceBright: const Color(0xFFEFEFEF),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      surfaceTintColor: Colors.white,
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 5),
    ),
    tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,

      headerBackgroundColor: color,
      headerForegroundColor: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      todayForegroundColor: WidgetStatePropertyAll(Colors.white),

      todayBorder: BorderSide(color: color),
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: Colors.black),
      cancelButtonStyle: TextButton.styleFrom(foregroundColor: Colors.black),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      hourMinuteColor: color,
      hourMinuteTextColor: Colors.white,

      dayPeriodColor: color,
      dayPeriodTextColor: Colors.white,

      dialBackgroundColor: const Color(0xFFEFEFEF),
      dialHandColor: color,
      dialTextColor: Colors.black,

      cancelButtonStyle: TextButton.styleFrom(foregroundColor: Colors.black),
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: Colors.black),
    ),
  );
}
