import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/features/products/domain/models/products_model.dart';
import 'package:wekala_waiter/features/sell_pos/controllers/pos_controller.dart';
import 'package:wekala_waiter/util/app_constants.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class ProductViewWidget extends StatelessWidget {
  final PosController posController;
  final Product product;
  final bool isSelected;
  final bool isOrderScreen;

  const ProductViewWidget({
    super.key,
    required this.product,
    required this.posController,
    this.isSelected = true,
    this.isOrderScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final newQuantity = posController.getProductQuantity(product);
    final oldQuantity = posController.getProductOldQuantity(product);
    final bool isAvailable = product.isAvailable;

    final colorScheme = Theme.of(context).colorScheme;

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.55,
      child: Column(
        children: [
          Row(
            children: [
              if (!isOrderScreen)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !isAvailable
                        ? colorScheme.surfaceContainerHighest
                        : isSelected
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                  ),
                  child: Icon(
                    !isAvailable
                        ? Icons.block_outlined
                        : isSelected
                        ? Icons.check
                        : Icons.shopping_bag_outlined,
                    color: !isAvailable
                        ? colorScheme.error
                        : isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    size: context.iconSize,
                  ),
                )
              else
                IconButton(
                  onPressed: () => posController.toggleProduct(product),
                  icon: Icon(
                    Icons.delete_outline,
                    size: context.iconSize,
                    color: colorScheme.error,
                  ),
                ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: context.mediumFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${product.unit} • ${product.subSku}',
                      style: TextStyle(
                        fontSize: context.smallFont,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (!isAvailable)
                      Text(
                        'unavailable'.tr,
                        style: TextStyle(
                          fontSize: context.smallFont * 0.85,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.errorContainer,
                        ),
                      ),
                  ],
                ),
              ),

              Text(
                '${product.sellPriceIncTax.toStringAsFixed(2)} '
                '${AppConstants.currency}',
                style: TextStyle(
                  fontSize: context.smallFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Quantity controls
          if (isSelected) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'quantity'.tr}: $newQuantity'
                    '       ${getQuantityChangeMessage(newQuantity, oldQuantity)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radiusDefault,
                    ),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          posController.decreaseQuantity(product);
                        },
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4),
                        icon: Icon(Icons.remove, size: context.iconSize * 0.7),
                      ),
                      Text(
                        newQuantity.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: context.smallFont,
                        ),
                      ),

                      IconButton(
                        onPressed: newQuantity < product.quantityAvailable
                            ? () {
                                posController.increaseQuantity(product);
                              }
                            : null,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: -4),
                        icon: Icon(Icons.add, size: context.iconSize * 0.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String getQuantityChangeMessage(int newQuantity, int oldQuantity) {
    final bool isold = product.transactionSellLinesId != null;
    if (isold) {
      if (newQuantity > oldQuantity) {
        return 'quantity_increased'.trParams({
          'count': '${newQuantity - oldQuantity}',
        });
      }

      if (newQuantity < oldQuantity) {
        return 'quantity_decreased'.trParams({
          'count': '${oldQuantity - newQuantity}',
        });
      }
    }
    return '';
  }
}
