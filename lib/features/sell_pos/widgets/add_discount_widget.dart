import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/discount_type.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/core/widgets/custom_dropdown_field.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class AddDiscountWidget extends StatefulWidget {
  const AddDiscountWidget({super.key});

  @override
  State<AddDiscountWidget> createState() => _AddDiscountWidgetState();
}

class _AddDiscountWidgetState extends State<AddDiscountWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _discountAmountController =
      TextEditingController();

  DiscountType? _discountType;

  @override
  void initState() {
    super.initState();

    final posController = Get.find<PosController>();

    _discountType = posController.discountType;

    _discountAmountController.text = posController.discountValue.toString();
  }

  @override
  void dispose() {
    _discountAmountController.dispose();
    super.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'edit_discount'.tr,
                      style: TextStyle(fontSize: context.largeFont),
                    ),
                    trailing: IconButton(
                      tooltip: 'close'.tr,
                      onPressed: Get.back,
                      icon: Icon(Icons.close, size: context.iconSize * 0.9),
                    ),
                  ),

                  const SizedBox(height: 15),

                  CustomDropdownFormField<DiscountType>(
                    label: 'discount_type'.tr,
                    hint: 'please_select'.tr,
                    initialValue: _discountType,
                    items: [
                      DropdownMenuItem(
                        value: DiscountType.fixed,
                        child: Text('fixed'.tr),
                      ),
                      DropdownMenuItem(
                        value: DiscountType.percent,
                        child: Text('percentage'.tr),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _discountType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.name.isEmpty) {
                        return 'discount_type_required'.tr;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  CustomTextField(
                    label: 'discount_amount'.tr,
                    hint: '0.0',
                    controller: _discountAmountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    required: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'discount_amount_required'.tr;
                      }

                      final amount = double.tryParse(value.trim());

                      if (amount == null) {
                        return 'invalid_discount_amount'.tr;
                      }

                      if (amount <= 0) {
                        return 'discount_amount_must_be_greater_than_zero'.tr;
                      }

                      if (_discountType == DiscountType.percent &&
                          amount > 100) {
                        return 'discount_percentage_max'.tr;
                      }

                      return null;
                    },
                  ),

                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return CustomButtonWidget(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            final amount = double.parse(
                              _discountAmountController.text.trim(),
                            );

                            posController.editDiscount(
                              type: _discountType!,
                              value: amount,
                            );

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
          ),
        );
      },
    );
  }
}
