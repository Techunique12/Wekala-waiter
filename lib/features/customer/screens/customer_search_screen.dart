import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/customer/controllers/customer_controller.dart';
import 'package:wekala_waiter/features/customer/domain/models/customer_model.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  late CustomerController controller;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = Get.find<CustomerController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCustomers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'select_customer'.tr,
          style: TextStyle(fontSize: context.largeFont),
        ),
      ),
      body: Column(
        children: [
          _buildSearchField(context, controller, searchController),

          Expanded(
            child: GetBuilder<CustomerController>(
              builder: (customerController) {
                if (customerController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (customerController.customers.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildCustomersList(
                  context,
                  customerController.customers,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSearchField(
  BuildContext context,
  CustomerController controller,
  TextEditingController searchController,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: Dimensions.paddingSizeExtraSmall,
      vertical: Dimensions.paddingSizeDefault,
    ),
    child: ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, child) {
        final hasText = value.text.isNotEmpty;

        return CustomTextField(
          textInputAction: TextInputAction.search,
          hint: 'search_customer'.tr,
          controller: searchController,
          onChanged: controller.onSearchChanged,
          suffixWidget: hasText
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    controller.clearSearch();
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
        );
      },
    ),
  );
}

Widget _buildCustomersList(BuildContext context, List<Customer> customers) {
  return ListView.separated(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
    itemCount: customers.length,
    separatorBuilder: (_, _) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      return _buildCustomerItem(context, customers[index]);
    },
  );
}

Widget _buildCustomerItem(BuildContext context, Customer customer) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final name = customer.text?.trim();
  final mobile = customer.mobile.trim();

  final displayName = name?.isNotEmpty == true ? name! : 'unknown_customer'.tr;

  final hasMobile = mobile.isNotEmpty == true;

  final discount = customer.discountPercent;

  return ListTile(
    dense: true,
    onTap: () {
      final posController = Get.find<PosController>();

      posController.selectCustomer(customer);

      Get.back(result: customer);
    },
    title: Text(
      displayName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: context.mediumFont,
        fontWeight: FontWeight.w500,
      ),
    ),
    subtitle: hasMobile
        ? Text('📞 $mobile', style: TextStyle(fontSize: context.smallFont))
        : null,
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (discount != null)
          Text(
            '$discount%',
            style: TextStyle(
              fontSize: context.smallFont,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),

        const SizedBox(width: 8),

        Icon(Icons.chevron_right_rounded, size: context.iconSize),
      ],
    ),
  );
}

Widget _buildEmptyState(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'no_customers_found'.tr,
            style: TextStyle(fontSize: context.mediumFont),
          ),

          const SizedBox(height: 4),

          Text(
            'search_by_name_phone_or_id'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: context.smallFont,
            ),
          ),
        ],
      ),
    ),
  );
}
