import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/add_tax_widget.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class OrderCalculationWidget extends GetView<PosController> {
  const OrderCalculationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              _buildCalculationItem(
                context,
                title: 'subtotal'.tr,
                value: controller.subtotal.toStringAsFixed(2),
              ),

              if (controller.discount != 0)
                _buildCalculationItem(
                  context,
                  title: 'discount'.tr,
                  value: controller.discount.toStringAsFixed(2),
                ),

              InkWell(
                onTap: () {
                  Get.bottomSheet(
                    AddTaxWidget(),
                    isScrollControlled: true,
                    ignoreSafeArea: false,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  );
                },
                child: _buildCalculationItem(
                  context,
                  title: 'order_tax'.tr,
                  value: controller.orderTax.toStringAsFixed(2),
                ),
              ),

              _buildCalculationItem(
                context,
                title: 'service_price'.tr,
                value: controller.servicePrice.toStringAsFixed(2),
              ),

              const Divider(),

              _buildCalculationItem(
                context,
                title: 'total_payable'.tr,
                value: controller.totalPayable.toStringAsFixed(2),
                isTotal: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalculationItem(
    BuildContext context, {
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeExtraSmall * 0.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? context.mediumFont : context.smallFont,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          Text(
            value,
            style: TextStyle(
              color: isTotal ? Colors.blue : null,
              fontSize: isTotal ? context.mediumFont : context.smallFont,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
