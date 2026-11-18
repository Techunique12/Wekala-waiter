import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/products/controllers/products_controller.dart';
import 'package:wekala_waiter/features/products/widgets/product_view_widget.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductsController controller = Get.find<ProductsController>();
  final PosController posController = Get.find<PosController>();

  late final TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final Map<int, int> quantities = {};

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      controller.getProducts(loadMore: true);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  int getQuantity(int productId) {
    return quantities[productId] ?? 1;
  }

  void increaseQuantity(int productId) {
    setState(() {
      quantities[productId] = getQuantity(productId) + 1;
    });
  }

  void decreaseQuantity(int productId) {
    setState(() {
      final quantity = getQuantity(productId);

      if (quantity > 1) {
        quantities[productId] = quantity - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'products'.tr,
          style: TextStyle(fontSize: context.largeFont),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          children: [
            CustomTextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              hint: 'search_products'.tr,
              onChanged: (value) {
                setState(() {});
                controller.searchProducts(value);
              },
              suffixWidget: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        controller.clearSearch();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    )
                  : null,
            ),

            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<ProductsController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (controller.products.isEmpty) {
                    return Center(child: Text('no_products_found'.tr));
                  }

                  return GetBuilder<PosController>(
                    builder: (posController) {
                      return ListView.builder(
                        controller: scrollController,
                        itemCount:
                            controller.products.length +
                            (controller.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.products.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          }

                          final product = controller.products[index];

                          final isSelected = posController.isProductSelected(
                            product,
                          );

                          return InkWell(
                            onTap: product.isAvailable
                                ? () async {
                                    await posController.toggleProduct(product);
                                  }
                                : null,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.08)
                                    : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusDefault,
                                ),
                              ),
                              child: ProductViewWidget(
                                product: product,
                                posController: posController,
                                isSelected: isSelected,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
