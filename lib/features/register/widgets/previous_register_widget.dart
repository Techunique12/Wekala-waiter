import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/extensions/date_time_extensions.dart';
import 'package:wekala_waiter/core/extensions/double_extensions.dart';
import 'package:wekala_waiter/features/register/controllers/register_controller.dart';
import 'package:wekala_waiter/features/register/domain/models/register_close_model.dart';
import 'package:wekala_waiter/features/register/widgets/register_row_widget.dart';
import 'package:wekala_waiter/util/app_constants.dart';

class PreviousRegisterWidget extends StatefulWidget {
  final double closingAmount;
  const PreviousRegisterWidget({super.key, required this.closingAmount});

  @override
  State<PreviousRegisterWidget> createState() => _PreviousRegisterWidgetState();
}

class _PreviousRegisterWidgetState extends State<PreviousRegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator.adaptive());
        }

        final data = controller.registerCloseData;

        if (data == null ||
            data.data == null ||
            data.data!.registerDetails == null ||
            data.data!.details == null) {
          return const Center(child: Text('Something went wrong'));
        }

        final registerDetails = data.data!.registerDetails;
        final details = data.data!.details;

        if (registerDetails == null || details == null) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }
        final total =
            registerDetails.cashInHand +
            registerDetails.totalSale -
            registerDetails.totalRefund -
            registerDetails.totalExpense;
        return SizedBox(
          height: context.screenHeight / 1.1,
          child: Column(
            children: [
              ListTile(
                trailing: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    ListTile(
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
                    ),

                    const SizedBox(height: 10),

                    _buildPaymentHeader(),

                    RegisterRowWidget(
                      title: 'cash_in_hand',
                      sell: registerDetails.cashInHand,
                    ),

                    RegisterRowWidget(
                      title: 'cash_payment',
                      sell: registerDetails.totalCash,
                      expense: registerDetails.totalCashExpense,
                    ),

                    RegisterRowWidget(
                      title: 'cheque_payment',
                      sell: registerDetails.totalCheque,
                      expense: registerDetails.totalChequeExpense,
                    ),

                    RegisterRowWidget(
                      title: 'card_payment',
                      sell: registerDetails.totalCard,
                      expense: registerDetails.totalCardExpense,
                    ),

                    RegisterRowWidget(
                      title: 'bank_transfer',
                      sell: registerDetails.totalBankTransfer,
                      expense: registerDetails.totalBankTransferExpense,
                    ),

                    RegisterRowWidget(
                      title: 'advance_payment',
                      sell: registerDetails.totalAdvance,
                      expense: registerDetails.totalAdvanceExpense,
                    ),

                    RegisterRowWidget(
                      title: 'other_payments',
                      sell: registerDetails.totalOther,
                      expense: registerDetails.totalOtherExpense,
                    ),

                    const Divider(indent: 15, endIndent: 15),

                    RegisterRowWidget(
                      title: 'total_sales',
                      sell: registerDetails.totalSale,
                      showExpense: false,
                    ),

                    RegisterRowWidget(
                      title: 'total_refund',
                      sell: registerDetails.totalRefund,
                      showExpense: false,
                    ),

                    RegisterRowWidget(
                      title: 'total_expense',
                      sell: registerDetails.totalExpense,
                      showExpense: false,
                    ),
                    const Divider(indent: 15, endIndent: 15),
                    Text(
                      '${'total'.tr} = '
                      ' ${AppConstants.currency} $total',
                      style: TextStyle(fontSize: context.smallFont),
                    ),
                    Text(
                      '${'total'.tr} = '
                      '${'opening'.tr} + '
                      '${'sale'.tr} - '
                      '${'refund'.tr} - '
                      '${'expense'.tr} ',
                      style: TextStyle(fontSize: context.smallFont),
                    ),

                    const Divider(indent: 15, endIndent: 15),

                    _buildProductDetails(details),

                    const Divider(indent: 15, endIndent: 15),

                    _buildProductDetailsByBrand(details),

                    const Divider(indent: 15, endIndent: 15),
                    Text(
                      'register_details'.tr,
                      style: TextStyle(
                        fontSize: context.mediumFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('expected_cash'.tr),
                        Text(
                          '${registerDetails.cashInHand.toStringAsFixed(2)} ${AppConstants.currency}',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('actual_cash_counted'.tr),
                        Text(
                          '${widget.closingAmount.toStringAsFixed(2)} ${AppConstants.currency}',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('difference'.tr),
                        Text(
                          registerDetails.cashInHand.isBalanced(
                            widget.closingAmount,
                          ),
                        ),
                      ],
                    ),
                    const Divider(indent: 15, endIndent: 15),
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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'payment_method'.tr,
              style: TextStyle(
                fontSize: context.mediumFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'sell'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.mediumFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'expense'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.mediumFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(RegisterDetailsDataModel details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sold_product_details'.tr,
          style: TextStyle(
            fontSize: context.mediumFont,
            fontWeight: FontWeight.w600,
          ),
        ),

        if (details.productDetails.isEmpty)
          _buildEmptyData()
        else
          _buildProductTable(details.productDetails),
      ],
    );
  }

  Widget _buildProductDetailsByBrand(RegisterDetailsDataModel details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sold_product_details_by_brand'.tr,
          style: TextStyle(
            fontSize: context.mediumFont,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        if (details.productDetailsByBrand.isEmpty)
          _buildEmptyData()
        else
          _buildBrandTable(details.productDetailsByBrand),
      ],
    );
  }

  Widget _buildEmptyData() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: Text(
          'no_data'.tr,
          style: TextStyle(
            fontSize: context.smallFont,
            color: Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }

  Widget _buildProductTable(List<ProductDetailsModel> products) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '#',
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'SKU',
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'product'.tr,
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'quantity'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'total'.tr,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...products.asMap().entries.map(
          (entry) => _buildProductRow(context, entry.key + 1, entry.value),
        ),
      ],
    );
  }

  Widget _buildProductRow(
    BuildContext context,
    int index,
    ProductDetailsModel product,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$index',
              style: TextStyle(fontSize: context.smallFont),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${product.sku}',
              style: TextStyle(fontSize: context.smallFont),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${product.productName}',
              style: TextStyle(fontSize: context.smallFont),
            ),
          ),
          Expanded(
            child: Text(
              '${product.totalQuantity}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.smallFont),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${AppConstants.currency} '
              '${product.totalAmount}',
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: context.smallFont),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandTable(List<ProductBrandDetailsModel> brands) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '#',
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'brand'.tr,
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'quantity'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'total'.tr,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...brands.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${entry.key + 1}',
                    style: TextStyle(fontSize: context.smallFont),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    entry.value.brandName ?? '-',
                    style: TextStyle(fontSize: context.smallFont),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${entry.value.totalQuantity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: context.smallFont),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${AppConstants.currency} '
                    '${entry.value.totalAmount}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: context.smallFont),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
