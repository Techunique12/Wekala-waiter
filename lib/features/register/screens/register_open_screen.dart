import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/core/widgets/custom_dropdown_field.dart';
import 'package:wekala_waiter/util/dimensions.dart';
import 'package:wekala_waiter/util/images.dart';

class RegisterOpenScreen extends StatefulWidget {
  const RegisterOpenScreen({super.key});

  @override
  State<RegisterOpenScreen> createState() => _RegisterOpenScreenState();
}

class _RegisterOpenScreenState extends State<RegisterOpenScreen> {
  final TextEditingController _amountController = TextEditingController();

  String? selectedLocationId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RegisterController>(
        builder: (registerController) {
          final locations =
              registerController.registerCheckModel?.data?.businessLocations;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
            ),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    Images.cashShiftLottie,
                    width: context.screenWidth / 2,
                    height: context.screenHeight / 4,
                    fit: BoxFit.contain,
                    repeat: true,
                  ),

                  CustomTextField(
                    label: 'cash_in_drawer'.tr,
                    hint: 'enter_amount'.tr,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    controller: _amountController,
                  ),
                  SizedBox(height: 10),
                  CustomDropdownFormField<String>(
                    label: 'business_location'.tr,
                    hint: 'select_location'.tr,
                    initialValue: selectedLocationId,
                    items:
                        locations?.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(
                              entry.value,
                              style: TextStyle(fontSize: context.mediumFont),
                            ),
                          );
                        }).toList() ??
                        [],
                    onChanged: (value) {
                      setState(() {
                        selectedLocationId = value;
                      });
                    },
                  ),

                  CustomButtonWidget(
                    isLoading: registerController.isLoading,
                    buttonText: 'start_new_shift'.tr,
                    width: context.screenWidth / 1.1,
                    margin: EdgeInsets.only(top: Dimensions.paddingSizeDefault),

                    onPressed: () async {
                      if (selectedLocationId == null) {
                        showCustomSnackBar('select_location'.tr);
                        return;
                      }

                      final double? amount = double.tryParse(
                        _amountController.text.trim(),
                      );

                      if (amount == null) {
                        showCustomSnackBar('enter_amount'.tr);
                        return;
                      }

                      await registerController.openCashRegister(
                        locationId: int.parse(selectedLocationId!),
                        amount: amount,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
