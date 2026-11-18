import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final bool isDestructiveAction;

  const CustomDialog({
    super.key,
    required this.title,
    this.description,
    this.cancelText,
    required this.confirmText,
    required this.onConfirm,
    this.isDestructiveAction = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: theme.brightness,
        primaryColor: theme.colorScheme.primary,
      ),
      child: CupertinoAlertDialog(
        title: Text(title, style: TextStyle(fontSize: context.mediumFont)),

        content: description != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  description!,
                  style: TextStyle(fontSize: context.smallFont),
                ),
              )
            : null,

        actions: [
          CupertinoDialogAction(
            onPressed: Get.back,
            child: Text(
              cancelText ?? 'cancel'.tr,
              style: TextStyle(color: CupertinoTheme.of(context).primaryColor),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructiveAction,
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
