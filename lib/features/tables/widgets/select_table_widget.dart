import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/extensions/translation_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_dialog.dart';
import 'package:wekala_waiter/features/tables/controllers/tables_controller.dart';
import 'package:wekala_waiter/features/tables/domain/models/table_model.dart';
import 'package:wekala_waiter/features/tables/widgets/table_details_widget.dart';
import 'package:wekala_waiter/helper/table_status_helper.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class SelectTableWidget extends StatelessWidget {
  final int? transactionId;
  const SelectTableWidget({super.key, this.transactionId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: GetBuilder<TablesController>(
        builder: (tablesController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, theme, tablesController.tables.length),

              Divider(height: 0, color: Colors.grey, indent: 10, endIndent: 10),

              _buildStatusLegend(context),

              _buildTables(context, theme, tablesController),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, int tableCount) {
    return ListTile(
      leading: Icon(
        Icons.table_restaurant,
        color: theme.primaryColor,
        size: context.iconSize,
      ),
      title: Text(
        'select_table'.tr,
        style: TextStyle(
          fontSize: context.mediumFont,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '$tableCount ${'tables'.tr}',
        style: TextStyle(fontSize: context.smallFont, color: theme.hintColor),
      ),
      trailing: IconButton(
        tooltip: 'close'.tr,
        onPressed: Get.back,
        icon: Icon(Icons.close, size: context.iconSize * 0.9),
      ),
    );
  }

  Widget _buildStatusLegend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _statusItem(context, text: 'available', color: Colors.green),
          _statusItem(context, text: 'occupied', color: Colors.red),
          _statusItem(context, text: 'reserved', color: Colors.deepPurple),
          _statusItem(context, text: 'unavailable', color: Colors.grey),
        ],
      ),
    );
  }

  Widget _statusItem(
    BuildContext context, {
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text.tr,
          style: TextStyle(
            fontSize: context.smallFont,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTables(
    BuildContext context,
    ThemeData theme,
    TablesController controller,
  ) {
    if (controller.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final List<TableModel> filteredTables;

    if (transactionId == null) {
      // No current table → show all tables
      filteredTables = controller.tables;
    } else {
      // Current table exists → show only available tables
      // except the current table itself
      filteredTables = controller.tables.where((table) {
        return table.status.toLowerCase() == 'available';
      }).toList();
    }

    if (filteredTables.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Text(
          'no_tables_available'.tr,
          style: TextStyle(
            fontSize: context.mediumFont,
            color: theme.hintColor,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 12.0;
          const minCardWidth = 120.0;

          final columns = (constraints.maxWidth / (minCardWidth + spacing))
              .floor()
              .clamp(1, 6);

          final cardWidth =
              (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

          return Align(
            alignment: AlignmentGeometry.centerStart,
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: filteredTables.map((table) {
                return SizedBox(
                  width: cardWidth,
                  child: _TableCard(
                    table: table,
                    onTap: () {
                      Get.close(1);
                      if (transactionId == null) {
                        Get.bottomSheet(
                          TableDetailsWidget(table: table),
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
                        );
                      } else {
                        Get.dialog(
                          CustomDialog(
                            title: 'move_order'.tr,
                            description: 'move_order_to_table'.trParams({
                              'table': table.name,
                            }),
                            confirmText: 'confirm_move'.tr,
                            onConfirm: () async {
                              if (transactionId != null) {
                                await controller.changeTable(
                                  transactionId: transactionId!,
                                  newTableId: table.id,
                                );
                              }
                            },
                          ),
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class _TableCard extends StatelessWidget {
  final TableModel table;
  final VoidCallback onTap;

  const _TableCard({required this.table, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color statusColor = TableStatusHelper.color(table.status);

    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          border: Border.all(color: statusColor.withValues(alpha: 0.35)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (table.capacity != null)
                    Text(
                      '${table.capacity} ${'seats'.tr}',
                      style: TextStyle(fontSize: context.smallFont * 0.8),
                    ),
                  Icon(
                    Icons.table_restaurant,
                    color: statusColor,
                    size: context.iconSize * 0.7,
                  ),
                  const Spacer(),
                  Text(
                    '#${table.id}',
                    style: TextStyle(
                      fontSize: context.smallFont,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                table.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.mediumFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (table.customerName != null)
                Text(
                  '${table.customerName} ${table.itemCount != null ? '-  ${'items_count'.itemsCount(table.itemCount ?? 0)}' : ""}${table.guests != null ? '-  ${'guests_count'.guestsCount(table.guests ?? 0)}' : ""}',
                  style: TextStyle(fontSize: context.smallFont * 0.9),
                ),
              if (table.bookingTime != null)
                Text(
                  table.bookingTime!.toLowerCase().tr,
                  style: TextStyle(fontSize: context.smallFont * 0.9),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
