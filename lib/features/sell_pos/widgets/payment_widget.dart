import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/pos_order_action.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_snackbar_widget.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/core/widgets/custom_dropdown_field.dart';
import 'package:wekala_waiter/util/app_constants.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({super.key});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final posController = Get.find<PosController>();

    amountController.text = posController.totalPayable.toStringAsFixed(2);

    amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    amountController.removeListener(_onAmountChanged);
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosController>(
      builder: (posController) {
        final double total = posController.totalPayable;

        final double paid =
            double.tryParse(amountController.text.trim()) ?? 0.0;

        final double change = paid > total ? paid - total : 0.0;

        final double due = total > paid ? total - paid : 0.0;

        final int totalItemsCount = posController.selectedProducts.length;

        return Form(
          key: _globalKey,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'payment'.tr,
                        style: TextStyle(
                          fontSize: context.largeFont,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close, size: context.iconSize),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${'available_balance'.tr} '
                      '${posController.customer?.balance ?? 0.0} '
                      '${AppConstants.currency}',
                      style: TextStyle(
                        fontSize: context.smallFont,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildPaymentMethod(posController),

                    const SizedBox(height: 16),

                    _buildAmountField(),

                    const SizedBox(height: 20),

                    _buildOrderSummary(
                      total: total,
                      paid: paid,
                      change: change,
                      due: due,
                      totalItems: totalItemsCount,
                    ),

                    const SizedBox(height: 20),

                    _buildPayButton(posController: posController, total: total),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethod(PosController posController) {
    return CustomDropdownFormField<String>(
      label: 'payment_method'.tr,
      required: true,
      initialValue: posController.selectedPaymentMethod,
      items: posController.defaultPayments
          .map(
            (payment) => DropdownMenuItem<String>(
              value: payment.method,
              child: Text(getPaymentMethodName(payment.method)),
            ),
          )
          .toList(),
      onChanged: (value) => posController.selectPaymentMethod(value!),
    );
  }

  Widget _buildAmountField() {
    return CustomTextField(
      label: 'amount'.tr,
      controller: amountController,
      required: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'amount_required'.tr;
        }

        final double? amount = double.tryParse(value);

        if (amount == null) {
          return 'amount_invalid'.tr;
        }

        if (amount <= 0) {
          return 'amount_must_be_greater_than_zero'.tr;
        }

        return null;
      },
    );
  }

  Widget _buildOrderSummary({
    required double total,
    required double paid,
    required double change,
    required double due,
    required int totalItems,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double spacing = 12;

          final double itemWidth = (constraints.maxWidth - spacing) / 2;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing / 2,
            children: [
              // Total Items
              _buildSummaryItem(
                width: itemWidth,
                title: 'total_items'.tr,
                value: totalItems.toString(),
              ),

              // Total
              _buildSummaryItem(
                width: itemWidth,
                title: 'total'.tr,
                value: _formatCurrency(total),
              ),

              // Paid
              _buildSummaryItem(
                width: itemWidth,
                title: 'paid'.tr,
                value: _formatCurrency(paid),
              ),

              // Change
              _buildSummaryItem(
                width: itemWidth,
                title: 'change'.tr,
                value: _formatCurrency(change),
                highlighted: change > 0,
                highlightColor: colorScheme.primary,
              ),

              // Amount Due
              _buildSummaryItem(
                width: constraints.maxWidth,
                title: 'amount_due'.tr,
                value: _formatCurrency(due),
                highlighted: due > 0,
                highlightColor: colorScheme.error,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem({
    required double width,
    required String title,
    required String value,
    bool highlighted = false,
    Color? highlightColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color borderColor = highlighted
        ? (highlightColor ?? colorScheme.primary)
        : colorScheme.outline.withValues(alpha: 0.15);

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: highlighted ? borderColor.withValues(alpha: 0.07) : null,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: context.smallFont,
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              value,
              style: TextStyle(
                fontSize: context.mediumFont,
                fontWeight: FontWeight.w700,
                color: highlighted ? borderColor : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton({
    required PosController posController,
    required double total,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomButtonWidget(
          onPressed: () async {
            if (!_globalKey.currentState!.validate()) {
              return;
            }

            final double amount =
                double.tryParse(amountController.text.trim()) ?? 0.0;

            if (amount < total) {
              showCustomSnackBar('insufficient_payment_amount'.tr);
              return;
            }
            final bool success = await posController.saveOrder(
              action: PosOrderAction.pay,
              message: 'payment_completed_successfully'.tr,
            );

            if (success) {
              Get.close(1);
            }
          },
          buttonText: 'pay'.tr,
          width: constraints.maxWidth,
          isLoading: posController.isLoading,
        );
      },
    );
  }

  String _formatCurrency(double value) {
    return '${AppConstants.currency} ${value.toStringAsFixed(2)}';
  }

  String getPaymentMethodName(String method) {
    if (method.startsWith('custom_pay_')) {
      final String number = method.replaceFirst('custom_pay_', '');

      return '${'custom_payment'.tr} $number';
    }

    return method.tr;
  }
}
