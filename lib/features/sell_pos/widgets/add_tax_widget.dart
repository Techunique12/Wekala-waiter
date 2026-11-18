import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_dropdown_field.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';

import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/order_tax_model.dart';

import 'package:wekala_waiter/util/dimensions.dart';

class AddTaxWidget extends StatefulWidget {
  const AddTaxWidget({super.key});

  @override
  State<AddTaxWidget> createState() => _AddTaxWidgetState();
}

class _AddTaxWidgetState extends State<AddTaxWidget> {
  TaxRateModel? _selectedTax;

  @override
  void initState() {
    super.initState();

    final PosController posController = Get.find<PosController>();

    // Current value
    _selectedTax = posController.selectedOrderTax;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'edit_order_tax'.tr,
                    style: TextStyle(fontSize: context.largeFont),
                  ),
                  trailing: IconButton(
                    tooltip: 'close'.tr,
                    onPressed: Get.back,
                    icon: Icon(Icons.close, size: context.iconSize * 0.9),
                  ),
                ),

                const SizedBox(height: 15),

                // Order Tax
                CustomDropdownFormField<TaxRateModel>(
                  label: 'order_tax'.tr.replaceAll('(+)', ''),
                  hint: 'please_select'.tr,
                  initialValue: _selectedTax,
                  required: true,
                  items: posController.orderTaxes
                      .map(
                        (tax) => DropdownMenuItem<TaxRateModel>(
                          value: tax,
                          child: Text('${tax.name} (${tax.amount}%)'),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      _selectedTax = value?.id == null ? null : value;
                    });
                  },
                ),

                // Edit
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomButtonWidget(
                        onPressed: () {
                          posController.selectOrderTax(_selectedTax);

                          Get.back();
                        },
                        buttonText: 'edit'.tr,
                        margin: const EdgeInsets.only(
                          top: Dimensions.paddingSizeLarge,
                        ),
                        width: constraints.maxWidth / 1.1,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
