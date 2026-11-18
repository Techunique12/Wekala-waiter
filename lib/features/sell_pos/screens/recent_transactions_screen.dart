import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/sell_status.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/recent_transactions_controller.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/transaction_view_widget.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class RecentTransactionsScreen extends StatefulWidget {
  const RecentTransactionsScreen({super.key});

  @override
  State<RecentTransactionsScreen> createState() =>
      _RecentTransactionsScreenState();
}

class _RecentTransactionsScreenState extends State<RecentTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'recent_transactions'.tr,
          style: TextStyle(fontSize: context.largeFont),
        ),
        actions: [
          GetBuilder<RecentTransactionsController>(
            builder: (controller) {
              return _buildStatusSelector(controller);
            },
          ),
        ],
      ),

      body: GetBuilder<RecentTransactionsController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final transactions = controller.transactions;

          if (transactions.isEmpty) {
            return Center(
              child: Text(
                'no_data'.tr,
                style: TextStyle(fontSize: context.mediumFont),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshTransactions,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: transactions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return TransactionViewWidget(transaction: transactions[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusSelector(RecentTransactionsController controller) {
    return PopupMenuButton<SellStatus>(
      initialValue: controller.status,
      position: PopupMenuPosition.under,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      onSelected: controller.changeStatus,

      itemBuilder: (context) => [
        PopupMenuItem<SellStatus>(
          value: SellStatus.completed,
          child: Text(
            'final'.tr,
            style: TextStyle(fontSize: context.smallFont),
          ),
        ),

        PopupMenuItem<SellStatus>(
          value: SellStatus.draft,
          child: Text(
            'draft'.tr,
            style: TextStyle(fontSize: context.smallFont),
          ),
        ),
      ],

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.status == SellStatus.completed
                  ? 'final'.tr
                  : 'draft'.tr,
              style: TextStyle(
                fontSize: context.smallFont,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(width: 4),

            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
