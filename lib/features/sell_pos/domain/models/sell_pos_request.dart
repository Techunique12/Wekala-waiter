import 'package:wekala_waiter/core/enums/pos_order_action.dart';
import 'package:wekala_waiter/core/enums/sell_status.dart';

class SellPosRequest {
  final int locationId;
  final int contactId;
  final SellStatus status;
  final String discountType;
  final double discountAmount;
  final String? taxRateId;
  final double finalTotal;
  final int typesOfServiceId;
  final List<SellPosProductRequest> products;
  final List<SellPosPaymentRequest> payment;
  final String? note;
  final PosOrderAction orderAction;
  final int? resTableId;

  const SellPosRequest({
    required this.locationId,
    required this.contactId,
    required this.status,
    required this.discountType,
    required this.discountAmount,
    this.taxRateId,
    required this.finalTotal,
    required this.typesOfServiceId,
    required this.products,
    required this.payment,
    this.note,
    required this.orderAction,
    this.resTableId,
  });

  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'contact_id': contactId,
      'status': status.value,
      'is_suspend': orderAction == PosOrderAction.hold ? 1 : 0,
      'discount_type': discountType,
      'discount_amount': discountAmount,
      'tax_rate_id': taxRateId,
      'final_total': finalTotal,
      'types_of_service_id': typesOfServiceId,
      'products': products.map((product) => product.toJson()).toList(),
      'payment': orderAction == PosOrderAction.pay
          ? payment.map((payment) => payment.toJson()).toList()
          : [],
      'additional_notes': note,
      'res_table_id': orderAction == PosOrderAction.sendToKitchen
          ? resTableId
          : null,
    };
  }
}

class SellPosProductRequest {
  final int productId;
  final int variationId;
  final int quantity;
  final double unitPrice;
  final double unitPriceIncTax;
  final double itemTax;
  final int? taxId;
  final int enableStock;
  final String productType;

  const SellPosProductRequest({
    required this.productId,
    required this.variationId,
    required this.quantity,
    required this.unitPrice,
    required this.unitPriceIncTax,
    required this.itemTax,
    required this.taxId,
    required this.enableStock,
    required this.productType,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'variation_id': variationId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'unit_price_inc_tax': unitPriceIncTax,
      'item_tax': itemTax,
      'tax_id': taxId,
      'enable_stock': enableStock,
      'product_type': productType,
    };
  }
}

class SellPosPaymentRequest {
  final double amount;
  final String method;

  const SellPosPaymentRequest({required this.amount, required this.method});

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'method': method};
  }
}
