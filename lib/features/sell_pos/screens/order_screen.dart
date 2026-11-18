import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/features/products/widgets/product_view_widget.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/order_actions_widget.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/order_calculation_widget.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/order_checkout_widget.dart';
import 'package:wekala_waiter/features/tables/controllers/tables_controller.dart';
import 'package:wekala_waiter/features/tables/widgets/select_table_widget.dart';
import 'package:wekala_waiter/helper/route_helper.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class OrderScreen extends GetView<PosController> {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              controller.service.name,
              style: TextStyle(fontSize: context.largeFont),
            ),
            actions: [
              if (controller.service.requiresTable)
                _buildTableSelectorAppBar(context, controller),

              IconButton(
                onPressed: () {
                  if (controller.service.requiresTable &&
                      controller.selectedTable == null) {
                    showCustomSnackBar('please_select_table_first'.tr);
                    return;
                  }

                  Get.toNamed(RouteHelper.products);
                },
                icon: Icon(Icons.add, size: context.iconSize),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Products
                        _buildProductContent(context, posController),

                        const Spacer(),

                        // Bottom order section
                        const OrderActionsWidget(),

                        const OrderCalculationWidget(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: const OrderCheckoutWidget(),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('🧾', style: TextStyle(fontSize: context.iconSize * 3)),

        const SizedBox(height: 8),

        Text(
          'start_adding_products'.tr,
          style: TextStyle(fontSize: context.mediumFont),
        ),

        Text(
          'choose_product_to_add_to_order'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: context.smallFont,
          ),
        ),
      ],
    );
  }

  Widget _buildProductContent(BuildContext context, PosController controller) {
    if (controller.selectedProducts.isEmpty) {
      return Expanded(flex: 2, child: _buildEmptyState(context));
    }

    return Column(
      children: List.generate(controller.selectedProducts.length, (index) {
        final item = controller.selectedProducts[index];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
          ),
          child: ProductViewWidget(
            product: item.product,
            posController: controller,
            isOrderScreen: true,
          ),
        );
      }),
    );
  }

  Widget _buildTableSelectorAppBar(
    BuildContext context,
    PosController controller,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final table = controller.selectedTable;

    return CustomButtonWidget(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeExtraSmall,
      ),
      onPressed: () async {
        final tablesController = Get.find<TablesController>();

        await tablesController.getTables();

        if (!context.mounted) return;

        Get.dialog(const SelectTableWidget());
      },
      buttonText: table?.name ?? 'select_table'.tr,
      icon: Icons.table_restaurant_outlined,
      iconColor: colorScheme.primary,
      transparent: true,
    );
  }
}
