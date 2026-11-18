import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/pos_order_action.dart';

import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/loading_overlay_widget.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/add_discount_widget.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class OrderActionsWidget extends StatelessWidget {
  const OrderActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade900
        : Colors.grey.shade200;
    return GetBuilder<PosController>(
      builder: (posController) {
        return Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall,
          ),
          child: Row(
            children: [
              _buildAction(
                context,
                icon: Icons.percent,
                title: 'discount'.tr,
                onTap: () => Get.bottomSheet(
                  AddDiscountWidget(),
                  isScrollControlled: true,
                  ignoreSafeArea: false,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
              ),

              _buildAction(
                context,
                icon: Icons.pause_circle_outline,
                title: 'suspend'.tr,
                onTap: () {
                  if (posController.service.requiresTable &&
                      posController.selectedTable == null) {
                    showCustomSnackBar('please_select_table_first'.tr);
                    return;
                  }

                  if (posController.selectedProducts.isEmpty) {
                    showCustomSnackBar('no_products_added'.tr);
                    return;
                  }

                  Get.showOverlay(
                    asyncFunction: () async {
                      await posController.saveOrder(
                        action: PosOrderAction.hold,
                        message: 'order_held_successfully'.tr,
                      );
                    },
                    loadingWidget: const LoadingOverlayWidget(),
                  );
                },
              ),

              _buildAction(
                context,
                icon: Icons.kitchen_outlined,
                title: 'send_to_kitchen'.tr,
                outlined: false,
                onTap: posController.service.requiresTable
                    ? () {
                        if (posController.service.requiresTable &&
                            posController.selectedTable == null) {
                          showCustomSnackBar('please_select_table_first'.tr);
                          return;
                        }

                        if (posController.selectedProducts.isEmpty) {
                          showCustomSnackBar('no_products_added'.tr);
                          return;
                        }

                        Get.showOverlay(
                          asyncFunction: () async {
                            await posController.saveOrder(
                              action: PosOrderAction.sendToKitchen,
                              message: 'order_sent_to_kitchen_successfully'.tr,
                            );
                          },
                          loadingWidget: const LoadingOverlayWidget(),
                        );
                      }
                    : null,
              ),

              _buildAction(
                context,
                icon: Icons.save_outlined,
                title: 'save'.tr,
                onTap: () async {
                  if (posController.service.requiresTable &&
                      posController.selectedTable == null) {
                    showCustomSnackBar('please_select_table_first'.tr);
                    return;
                  }

                  if (posController.selectedProducts.isEmpty) {
                    showCustomSnackBar('no_products_added'.tr);
                    return;
                  }

                  Get.showOverlay(
                    asyncFunction: () async {
                      await posController.saveOrder(
                        action: PosOrderAction.save,
                        message: 'order_saved_successfully'.tr,
                      );
                    },
                    loadingWidget: const LoadingOverlayWidget(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
    bool outlined = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = onTap == null;

    return Expanded(
      flex: _getFlex(title),
      child: CustomButtonWidget(
        buttonText: title,
        onPressed: onTap,
        fontSize: context.smallFont,
        icon: icon,
        iconSize: context.iconSize,
        isBorder: outlined,

        color: isDisabled
            ? colorScheme.surfaceContainerHighest
            : outlined
            ? colorScheme.surface
            : null,

        textColor: isDisabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : outlined
            ? colorScheme.onSurface
            : null,

        iconColor: isDisabled
            ? colorScheme.onSurface.withValues(alpha: 0.38)
            : outlined
            ? colorScheme.onSurface
            : null,

        disabledColor: colorScheme.surfaceContainerHighest,

        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),

        iconAndTextVertical: true,

        margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraSmall,
        ),
      ),
    );
  }

  int _getFlex(String title) {
    if (title.length >= 15) {
      return 2;
    }

    if (title.length >= 10) {
      return 1;
    }

    return 1;
  }
}
