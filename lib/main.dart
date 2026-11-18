import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wekala_waiter/core/localization/app_translations.dart';
import 'package:wekala_waiter/core/localization/localization_controller.dart';
import 'package:wekala_waiter/core/route_observer.dart';
import 'package:wekala_waiter/core/theme/app_theme.dart';
import 'package:wekala_waiter/helper/get_di.dart' as di;
import 'package:wekala_waiter/helper/route_helper.dart';
import 'package:wekala_waiter/util/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();
  await di.init();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizationController) {
        return GetMaterialApp(
          navigatorObservers: [routeObserver],
          title: AppConstants.appName.tr,
          debugShowCheckedModeBanner: false,
          builder: DevicePreview.appBuilder,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          initialRoute: RouteHelper.authCheck,
          getPages: RouteHelper.routes,
          translations: AppTranslations(),
          locale: localizationController.locale,
          fallbackLocale: Locale(
            AppConstants.languages[0].languageCode!,
            AppConstants.languages[0].countryCode,
          ),
        );
      },
    );
  }
}
