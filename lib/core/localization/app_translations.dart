import 'package:get/get.dart';
import 'package:wekala_waiter/core/localization/language/ar.dart';
import 'package:wekala_waiter/core/localization/language/en.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'ar': ar};
}
