import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/calculator_dialog.dart';
import 'package:wekala_waiter/core/widgets/custom_dialog.dart';
import 'package:wekala_waiter/features/auth/controllers/auth_controller.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/helper/route_helper.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildBranchName(context),
      actions: [_buildMenu(context)],
    );
  }

  Widget _buildBranchName(BuildContext context) {
    final registerController = Get.find<RegisterController>();

    final registerData = registerController.currentRegister;
    if (registerData == null) {
      return SizedBox();
    }

    return Text(
      '${'branch'.tr}: ${registerData.locationName}',
      style: TextStyle(fontSize: context.mediumFont),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      ),
      onSelected: (value) {
        switch (value) {
          case 'close_register':
            Get.toNamed(RouteHelper.registerClose);
            break;

          case 'calculator':
            _showCalculator(context);
            break;

          case 'logout':
            _showLogoutDialog(context);
            break;
        }
      },
      itemBuilder: (context) => [
        _buildPopupMenuItem(context, value: 'close_register'),
        _buildPopupMenuItem(context, value: 'calculator'),
        _buildPopupMenuItem(context, value: 'logout', isDestructive: true),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    BuildContext context, {
    required String value,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        value.tr,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontSize: context.mediumFont,
        ),
      ),
    );
  }

  void _showCalculator(BuildContext context) {
    showDialog(context: context, builder: (_) => const CalculatorDialog());
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      CustomDialog(
        title: 'logout'.tr,
        description: 'logout_confirmation'.tr,
        confirmText: 'logout'.tr,
        onConfirm: () async {
          final authController = Get.find<AuthController>();
          await authController.logout();
        },
      ),
    );
  }
}
