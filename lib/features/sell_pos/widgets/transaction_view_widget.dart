import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/extensions/date_time_extensions.dart';
import 'package:wekala_waiter/features/sell_pos/domain/models/recent_transactions_model.dart';
import 'package:wekala_waiter/util/app_constants.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class TransactionViewWidget extends StatelessWidget {
  final RecentTransactionModel transaction;
  const TransactionViewWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPaid = transaction.paymentStatus == 'paid';

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${transaction.invoiceNo}',
                style: TextStyle(
                  fontSize: context.mediumFont,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Text(
                '${AppConstants.currency} '
                '${transaction.finalTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: context.mediumFont,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            transaction.contact?.name ?? 'walk_in_customer'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: context.smallFont,
              color: theme.hintColor,
            ),
          ),

          const SizedBox(height: 12),

          Divider(height: 0, color: theme.dividerColor),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: context.iconSize * 0.75,
                color: theme.hintColor,
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  transaction.transactionDate.formatDate,
                  style: TextStyle(
                    fontSize: context.smallFont * 0.9,
                    color: theme.hintColor,
                  ),
                ),
              ),
              if (transaction.paymentStatus.isNotEmpty)
                _buildPaymentStatus(context, transaction.paymentStatus, isPaid),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatus(
    BuildContext context,
    String? status,
    bool isPaid,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: (isPaid ? Colors.green : Theme.of(context).colorScheme.error)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: Text(
        status?.tr ?? '-',
        style: TextStyle(
          fontSize: context.smallFont * 0.85,
          fontWeight: FontWeight.w600,
          color: isPaid ? Colors.green : Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
