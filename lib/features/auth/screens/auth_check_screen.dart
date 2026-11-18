import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/api_request_status.dart';
import 'package:wekala_waiter/features/auth/controllers/auth_controller.dart';
import 'package:wekala_waiter/helper/route_helper.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Future<void> _checkLogin() async {
    final authController = Get.find<AuthController>();

    // No token → Sign In
    if (!authController.isLoggedIn()) {
      Get.offAllNamed(RouteHelper.signIn);
      return;
    }

    final status = await authController.getMe();

    switch (status) {
      case ApiRequestStatus.success:
      case ApiRequestStatus.noInternet:
      case ApiRequestStatus.timeout:
      case ApiRequestStatus.error:
        // User has a token → allow entering the app
        Get.offAllNamed(RouteHelper.registerCheck);
        break;

      case ApiRequestStatus.unauthorized:
        break;
    }
  }
}
