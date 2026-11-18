import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/extensions/date_time_extensions.dart';
import 'package:wekala_waiter/core/widgets/custom_dialog.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/features/register/domain/models/register_close_model.dart';
import 'package:wekala_waiter/features/register/widgets/previous_register_widget.dart';

class RegisterCloseScreen extends StatefulWidget {
  const RegisterCloseScreen({super.key});

  @override
  State<RegisterCloseScreen> createState() => _RegisterCloseScreenState();
}

class _RegisterCloseScreenState extends State<RegisterCloseScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController totalCardController = TextEditingController(text: '0');
  TextEditingController totalChequesController = TextEditingController(
    text: '0',
  );
  TextEditingController notesController = TextEditingController();
  @override
  void dispose() {
    totalAmountController.dispose();
    totalCardController.dispose();
    totalChequesController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      initState: (_) {
        Get.find<RegisterController>().getCashRegisterCloseData();
      },
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        final data = controller.registerCloseData;

        if (data == null || data.data == null) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        final registerDetails = data.data?.registerDetails;
        final details = data.data?.details;

        if (registerDetails == null || details == null) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'current_register'.tr,
              style: TextStyle(fontSize: context.largeFont),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: CustomButtonWidget(
              onPressed: () {
                if (!_globalKey.currentState!.validate()) {
                  return;
                }

                Get.dialog(
                  CustomDialog(
                    title: 'close_register'.tr,
                    description: 'close_register_confirmation'.tr,
                    confirmText: 'confirm'.tr,
                    onConfirm: () {
                      Get.bottomSheet(
                        PreviousRegisterWidget(
                          closingAmount: double.parse(
                            totalAmountController.text,
                          ),
                        ),
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
                      ).then((value) async {
                        final amount = double.parse(totalAmountController.text);
                        final totalCardSlips = int.parse(
                          totalCardController.text,
                        );
                        final totalCheques = int.parse(
                          totalChequesController.text,
                        );
                        // Close register API
                        final registerController =
                            Get.find<RegisterController>();
                        await registerController.closeCashRegister(
                          closingAmount: amount,
                          totalCardSlips: totalCardSlips,
                          totalCheques: totalCheques,
                          closingNote: notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                        );
                      });
                    },
                  ),
                );
              },
              buttonText: 'close_register'.tr,
              margin: const EdgeInsets.all(12),
            ),
          ),
          body: Form(
            key: _globalKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildRegisterDate(registerDetails),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'count_cash_before_closing'.tr,
                    style: TextStyle(
                      fontSize: context.smallFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'sales_report_after_shift_closing'.tr,
                      style: TextStyle(fontSize: context.smallFont * 0.9),
                    ),
                  ),
                ),
                CustomTextField(
                  label: 'total_cash'.tr,
                  hint: '0.0',
                  required: true,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  controller: totalAmountController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'total_cash_required'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'total_card_slips'.tr,
                        required: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: totalCardController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'total_card_slips_required'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'total_cheques'.tr,
                        required: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: totalChequesController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'total_cheques_required'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                CustomTextField(
                  label: 'closing_note'.tr,
                  maxLines: 4,
                  controller: notesController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 15),
                _buildRegisterInfo(registerDetails),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterDate(RegisterDetailsModel registerDetails) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'register_date'.tr,
        style: TextStyle(
          fontSize: context.mediumFont,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${registerDetails.openTime?.formatDate ?? '-'} - '
        '${registerDetails.closedAt?.formatDate ?? 'open'.tr}',
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: context.smallFont),
      ),
    );
  }

  Widget _buildRegisterInfo(RegisterDetailsModel registerDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${'user'.tr}: ${registerDetails.userName ?? '-'}',
          style: TextStyle(fontSize: context.smallFont),
        ),
        const SizedBox(height: 5),
        Text(
          '${'email'.tr}: ${registerDetails.email ?? '-'}',
          style: TextStyle(fontSize: context.smallFont),
        ),
        const SizedBox(height: 5),
        Text(
          '${'business_location'.tr}: '
          '${registerDetails.locationName ?? '-'}',
          style: TextStyle(fontSize: context.smallFont),
        ),
      ],
    );
  }
}
