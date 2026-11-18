import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_dialog.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/loading_overlay_widget.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/features/tables/controllers/tables_controller.dart';
import 'package:wekala_waiter/features/tables/domain/models/table_model.dart';
import 'package:wekala_waiter/features/tables/widgets/select_table_widget.dart';
import 'package:wekala_waiter/helper/route_helper.dart';
import 'package:wekala_waiter/helper/table_status_helper.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class TableDetailsWidget extends StatelessWidget {
  final TableModel table;

  const TableDetailsWidget({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TablesController>(
      builder: (controller) {
        final currentTable = controller.getTableById(table.id);

        if (currentTable == null) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, currentTable, controller);
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    TableModel table,
    TablesController controller,
  ) {
    final theme = Theme.of(context);
    final statusColor = TableStatusHelper.color(table.status);

    final hasBookingData =
        table.customerName != null ||
        table.customerPhone != null ||
        table.bookingDate != null ||
        table.guests != null ||
        table.itemCount != null ||
        table.total != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
          ),
          leading: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            table.name,
            style: TextStyle(
              fontSize: context.mediumFont,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            TableStatusHelper.name(table.status),
            style: TextStyle(fontSize: context.smallFont, color: statusColor),
          ),
          trailing: IconButton(
            tooltip: 'close'.tr,
            onPressed: Get.back,
            icon: Icon(Icons.close, size: context.iconSize * 0.9),
          ),
        ),

        if (hasBookingData)
          Card(
            margin: const EdgeInsets.all(
              Dimensions.paddingSizeDefault,
            ).copyWith(bottom: 0),
            elevation: 0,
            color: theme.focusColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (table.customerName != null)
                    _buildBookingInfoRow(
                      context,
                      title: 'customer_name',
                      value: table.customerName!,
                    ),

                  if (table.customerPhone != null)
                    _buildBookingInfoRow(
                      context,
                      title: 'phone_number',
                      value: table.customerPhone!.isEmpty
                          ? '--'
                          : table.customerPhone!,
                    ),

                  if (table.bookingDate != null)
                    _buildBookingInfoRow(
                      context,
                      title: 'date',
                      value:
                          '${table.bookingDate} * ${table.bookingTime ?? ''}',
                    ),

                  if (table.guests != null)
                    _buildBookingInfoRow(
                      context,
                      title: 'guests',
                      value: '${table.guests}',
                    ),

                  if (table.itemCount != null)
                    _buildBookingInfoRow(
                      context,
                      title: 'items',
                      value: '${table.itemCount}',
                    ),

                  if (table.total != null)
                    _buildBookingInfoRow(
                      context,
                      title: 'total',
                      value: '${table.total}',
                    ),
                ],
              ),
            ),
          ),

        _buildTableAction(context, table, controller),
      ],
    );
  }

  Widget _buildBookingInfoRow(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.tr,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: context.smallFont,
            ),
          ),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: context.smallFont,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableAction(
    BuildContext context,
    TableModel table,
    TablesController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = (constraints.maxWidth - 5) / 2;

          return Wrap(
            spacing: 5,
            children: _buildActions(context, buttonWidth, controller, table),
          );
        },
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    double buttonWidth,
    TablesController controller,
    TableModel table,
  ) {
    final posController = Get.find<PosController>();

    return switch (table.status) {
      'reserved' => [
        CustomButtonWidget(
          buttonText: 'checked_in'.tr,
          textColor: table.isArrived == true ? Colors.green : null,
          icon: Icons.how_to_reg_outlined,
          width: buttonWidth,
          transparent: true,
          isBorder: true,
          isLoading: controller.loadingAction == 'checked_in',
          onPressed: table.isArrived == true || table.bookingId == null
              ? null
              : () {
                  controller.checkInReservation(bookingId: table.bookingId!);
                },
        ),

        CustomButtonWidget(
          buttonText: 'start_order'.tr,
          icon: Icons.receipt_long_outlined,
          width: buttonWidth,
          onPressed: () {
            posController.selectTable(table);
            Get.back();
          },
        ),

        CustomButtonWidget(
          buttonText: 'cancel_reservation'.tr,
          icon: Icons.cancel_outlined,
          width: buttonWidth,
          transparent: true,
          isBorder: true,
          textColor: Theme.of(context).colorScheme.error,
          iconColor: Theme.of(context).colorScheme.error,
          isLoading: controller.loadingAction == 'cancel_reservation',
          onPressed: () {
            Get.dialog(
              CustomDialog(
                title: 'cancel_reservation'.tr,
                confirmText: 'cancel_reservation'.tr,
                cancelText: 'keep_reservation'.tr,
                description: 'cancel_reservation_confirmation'.tr,
                onConfirm: () {
                  if (table.bookingId == null) return;

                  Get.back();

                  controller.cancelReservation(bookingId: table.bookingId!);
                },
              ),
            );
          },
        ),

        CustomButtonWidget(
          buttonText: 'update_reservation'.tr,
          icon: Icons.edit_outlined,
          width: buttonWidth,
          transparent: true,
          isBorder: true,
          onPressed: () {
            Get.back();
            Get.toNamed(RouteHelper.reservedTable, arguments: table);
          },
        ),
      ],

      'occupied' => [
        // CustomButtonWidget(
        //   buttonText: 'send_to_kitchen'.tr,
        //   icon: Icons.kitchen_outlined,
        //   width: buttonWidth,
        //   transparent: true,
        //   isBorder: true,
        //   onPressed: table.pendingKitchen == true ? null : () {},
        // ),
        CustomButtonWidget(
          buttonText: 'switch_table'.tr,
          icon: Icons.swap_horiz_outlined,
          width: buttonWidth,
          transparent: true,
          isBorder: true,
          onPressed: () async {
            Get.back();

            final tablesController = Get.find<TablesController>();

            tablesController.getTables();

            Get.dialog(SelectTableWidget(transactionId: table.transactionId));
          },
        ),

        CustomButtonWidget(
          buttonText: 'pay_and_close'.tr,
          icon: Icons.payments_outlined,
          width: buttonWidth,
          transparent: true,
          isBorder: true,
          onPressed: () async {
            await Get.showOverlay(
              asyncFunction: () async {
                if (table.transactionId == null) {
                  return;
                }

                Get.back();

                final posController = Get.find<PosController>();

                posController.setEditingTransactionId(table.transactionId!);

                await posController.loadOrderForEdit();
              },
              loadingWidget: const LoadingOverlayWidget(),
            );
          },
        ),
        CustomButtonWidget(
          buttonText: 'view_add_items'.tr,
          width: buttonWidth * 2,
          onPressed: () async {
            await Get.showOverlay(
              asyncFunction: () async {
                if (table.transactionId == null) {
                  return;
                }

                Get.back();

                final posController = Get.find<PosController>();

                posController.setEditingTransactionId(table.transactionId!);

                await posController.loadOrderForEdit();
              },
              loadingWidget: const LoadingOverlayWidget(),
            );
          },
        ),
      ],

      'available' => [
        CustomButtonWidget(
          buttonText: 'open_new_order'.tr,
          icon: Icons.add,
          width: buttonWidth,
          onPressed: () {
            posController.selectTable(table);
            Get.back();
          },
        ),
        CustomButtonWidget(
          buttonText: 'reserve_table'.tr,
          icon: Icons.event_available_outlined,
          width: buttonWidth,
          transparent: true,
          isBorder: true,
          onPressed: () {
            Get.back();
            Get.toNamed(RouteHelper.reservedTable, arguments: table);
          },
        ),
      ],

      _ => [],
    };
  }
}
