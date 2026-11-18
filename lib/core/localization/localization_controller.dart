import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class LocalizationController extends GetxController {
  final SharedPreferences prefs;

  LocalizationController({required this.prefs});

  Locale get locale {
    final languageCode = prefs.getString(AppConstants.languageKey);

    if (languageCode != null) {
      return Locale(languageCode);
    }

    return Get.deviceLocale ?? const Locale('en');
  }

  Future<void> changeLanguage(String languageCode) async {
    await prefs.setString(AppConstants.languageKey, languageCode);

    Get.updateLocale(Locale(languageCode));
  }

  bool get isArabic => locale.languageCode == 'ar';

  bool get isEnglish => locale.languageCode == 'en';
}
