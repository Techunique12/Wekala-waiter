import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/enums/sell_status.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/extensions/date_time_extensions.dart';
import 'package:wekala_waiter/core/route_observer.dart';
import 'package:wekala_waiter/features/dashboard/widgets/current_date_time_widget.dart';
import 'package:wekala_waiter/features/dashboard/widgets/dashboard_app_bar.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/recent_transactions_controller.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/transaction_view_widget.dart';
import 'package:wekala_waiter/features/sell_pos/widgets/transactions_view_shimmer.dart';
import 'package:wekala_waiter/features/service/controllers/service_controller.dart';
import 'package:wekala_waiter/features/service/widgets/service_selection_widget.dart';
import 'package:wekala_waiter/helper/route_helper.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);

    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    if (Get.isRegistered<RecentTransactionsController>()) {
      Get.find<RecentTransactionsController>().getRecentTransactions(
        status: SellStatus.completed,
      );
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(),
      body: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeSmall,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'start_new_order'.tr,
                      style: TextStyle(
                        fontSize: context.mediumFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'choose_service_type'.tr,
                      style: TextStyle(
                        fontSize: context.smallFont,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),

              ServiceSelectionWidget(),
              ListTile(
                dense: true,
                onTap: () => Get.toNamed(RouteHelper.recentTransactions),
                title: Text(
                  'recent_transactions'.tr,
                  style: TextStyle(
                    fontSize: context.mediumFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: context.iconSize * 0.7,
                ),
              ),
              GetBuilder<RecentTransactionsController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const TransactionsViewShimmer();
                  }
                  List transactions = controller.transactions;
                  if (transactions.isEmpty) {
                    return Center(child: Text('no_data'.tr));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.take(3).length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      return TransactionViewWidget(transaction: transaction);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DateTime.now().greetingKey.tr,
            style: TextStyle(
              fontSize: context.largeFont,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'ready_to_take_orders'.tr,
            style: TextStyle(
              fontSize: context.smallFont,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 16),

          const CurrentDateTimeWidget(),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    final futures = <Future<void>>[];

    if (Get.isRegistered<ServiceController>()) {
      futures.add(Get.find<ServiceController>().getServices());
    }

    if (Get.isRegistered<RecentTransactionsController>()) {
      futures.add(
        Get.find<RecentTransactionsController>().getRecentTransactions(
          status: SellStatus.completed,
        ),
      );
    }

    await Future.wait(futures);
  }
}
