import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/features/auth/controllers/auth_controller.dart';

class ApiChecker {
  static void checkApi(Response response, {bool showError = true}) {
    debugPrint(
      '====> API Response: '
      '[${response.statusCode}] ${response.body}',
    );

    // 401 -> Always clear session.
    if (response.statusCode == 401) {
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().clearSession();
      }
      return;
    }

    // Don't show snackbar.
    if (!showError) {
      return;
    }

    // No Internet
    if (response.statusCode == 0) {
      showCustomSnackBar('no_internet_connection'.tr, isError: true);
      return;
    }

    // Timeout
    if (response.statusCode == -1) {
      showCustomSnackBar('connection_timeout'.tr, isError: true);
      return;
    }

    // Unexpected Error
    if (response.statusCode == -2) {
      showCustomSnackBar('something_went_wrong'.tr, isError: true);
      return;
    }

    final String message = response.statusText?.trim() ?? '';

    showCustomSnackBar(
      message.isNotEmpty ? message : 'something_went_wrong'.tr,
      isError: true,
    );
  }
}
