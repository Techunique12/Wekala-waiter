import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_dialog.dart';
import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/add_notes_widget.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/payment_widget.dart';
import 'package:wekala_waiter/helper/route_helper.dart';
import 'package:wekala_waiter/util/app_constants.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class OrderCheckoutWidget extends StatelessWidget {
  const OrderCheckoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) {
        return Padding(
          padding: const EdgeInsets.all(
            Dimensions.paddingSizeExtraSmall,
          ).copyWith(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExpansionTile(
                dense: true,
                shape: const Border(),
                collapsedShape: const Border(),
                leading: const Icon(Icons.person_outline),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'customer'.tr,
                      style: TextStyle(fontSize: context.mediumFont),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        posController.customer?.name ??
                            posController.customer?.text ??
                            '',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: context.smallFont),
                      ),
                    ),
                  ],
                ),
                subtitle: posController.isSelectedCustomer
                    ? Text(
                        '${'customer_due'.tr}: '
                        '${posController.selectedCustomerDue.toStringAsFixed(2)} '
                        '${AppConstants.currency}',
                        style: TextStyle(
                          fontSize: context.smallFont,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    : null,
                children: [
                  ListTile(
                    dense: true,
                    onTap: () {
                      Get.toNamed(RouteHelper.customerSearch);
                    },
                    title: Text(
                      'select_customer'.tr,
                      style: TextStyle(fontSize: context.smallFont),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: context.iconSize * 0.5,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: GetBuilder<PosController>(
                      builder: (posController) {
                        final hasNote =
                            posController.orderNote?.isNotEmpty == true;

                        return CustomButtonWidget(
                          onPressed: () {
                            Get.bottomSheet(
                              const AddNotesWidget(),
                              isScrollControlled: true,
                              ignoreSafeArea: false,
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                            );
                          },
                          buttonText: 'notes'.tr,
                          icon: hasNote
                              ? Icons.sticky_note_2_rounded
                              : Icons.note_outlined,
                          iconColor: hasNote
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          borderColor: hasNote
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          transparent: true,
                          isBorder: true,
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  if (posController.hasOrderData) ...[
                    Expanded(
                      child: CustomButtonWidget(
                        onPressed: () {
                          Get.dialog(
                            CustomDialog(
                              title: 'cancel_order'.tr,
                              description: 'cancel_order_confirmation'.tr,
                              cancelText: 'keep_order'.tr,
                              confirmText: 'yes_cancel'.tr,
                              onConfirm: posController.clearCurrentOrder,
                            ),
                          );
                        },
                        buttonText: 'cancel'.tr,
                        transparent: true,
                        icon: Icons.close,
                        textColor: Colors.red,
                        borderColor: Colors.red,
                        isBorder: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],

                  Expanded(
                    child: CustomButtonWidget(
                      onPressed: () {
                        // Validate table
                        if (posController.service.requiresTable &&
                            posController.selectedTable == null) {
                          showCustomSnackBar('please_select_table_first'.tr);
                          return;
                        }

                        // Validate products
                        if (posController.selectedProducts.isEmpty) {
                          showCustomSnackBar('no_products_added'.tr);
                          return;
                        }

                        // Open payment
                        Get.bottomSheet(
                          const PaymentWidget(),
                          isScrollControlled: true,
                          ignoreSafeArea: false,
                          backgroundColor: Theme.of(
                            context,
                          ).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                        );
                      },
                      buttonText: 'pay'.tr,
                      icon: Icons.payment_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
