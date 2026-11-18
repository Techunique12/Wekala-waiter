import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/helper/route_helper.dart';

class RegisterCheckScreen extends StatefulWidget {
  const RegisterCheckScreen({super.key});

  @override
  State<RegisterCheckScreen> createState() => _RegisterCheckScreenState();
}

class _RegisterCheckScreenState extends State<RegisterCheckScreen> {
  bool _isError = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkRegister();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isError ? _buildErrorView(context) : _buildLoadingView(context),
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator.adaptive(),
        const SizedBox(height: 16),
        Text(
          'register_check'.tr,
          style: TextStyle(fontSize: context.largeFont),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          'connection_error'.tr,
          style: TextStyle(
            fontSize: context.largeFont,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'please_check_your_internet_connection'.tr,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        CustomButtonWidget(
          buttonText: 'retry'.tr,
          onPressed: checkRegister,
          icon: Icons.refresh,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Future<void> checkRegister() async {
    if (_isLoading) return;

    setState(() {
      _isError = false;
      _isLoading = true;
    });

    final registerController = Get.find<RegisterController>();

    final success = await registerController.checkRegister();

    if (!mounted) return;

    if (!success) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
      return;
    }

    // Stop loading before navigation.
    setState(() {
      _isLoading = false;
    });

    if (registerController.isRegisterOpen) {
      Get.offAllNamed(RouteHelper.initial);
    } else {
      Get.offAllNamed(RouteHelper.registerOpen);
    }
  }
}
