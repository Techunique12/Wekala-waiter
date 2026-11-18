class ProductsModel {
  final bool success;
  final String? message;
  final ProductsData? data;

  ProductsModel({required this.success, this.message, this.data});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? ProductsData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class ProductsData {
  final List<Product> products;
  final Pagination pagination;
  final Map<String, dynamic> allowedGroupPrices;
  final bool showPrices;

  ProductsData({
    required this.products,
    required this.pagination,
    required this.allowedGroupPrices,
    required this.showPrices,
  });

  factory ProductsData.fromJson(Map<String, dynamic> json) {
    return ProductsData(
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      allowedGroupPrices:
          (json['allowed_group_prices'] as Map<String, dynamic>?) ?? {},
      showPrices: json['show_prices'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
      'allowed_group_prices': allowedGroupPrices,
      'show_prices': showPrices,
    };
  }
}

class Product {
  final int productId;
  final String name;

  final String? productActualName;
  final String type;

  final int enableStock;
  final int enableSrNo;

  final String? productImage;

  final String? productVariationName;

  final int isDummy;

  final String? variationName;

  final int variationId;

  final String subSku;

  final String? barcodeType;

  final double quantityAvailable;

  final String? formattedQuantityAvailable;

  final bool isAvailable;

  /// Price before tax.
  final double sellingPrice;

  /// Price before discount.
  final double unitPriceBeforeDiscount;

  /// Price including tax.
  final double sellPriceIncTax;

  /// Last purchased price.
  final double? lastPurchasedPrice;

  final String unit;

  final int? unitId;

  final int unitAllowDecimal;

  final String? secondUnit;

  final double secondaryUnitQuantity;

  final int? subUnitId;

  final int? taxId;

  /// Tax amount per item.
  final double itemTax;

  final int belongsToKitchen;

  final int? brandId;

  final int? categoryId;

  final int? warrantyId;

  final String? brand;

  final int? transactionSellLinesId;

  final int? id;

  final int quantityOrdered;

  final String? sellLineNote;

  final int? parentSellLineId;

  final int? lotNoLineId;

  final String? lineDiscountType;

  final double lineDiscountAmount;

  final List<dynamic> comboVariations;

  final List<dynamic> media;

  final List<dynamic> groupPrices;

  final List<dynamic> lotNumbers;

  final List<dynamic> modifiersIds;

  final List<dynamic> warranties;

  Product({
    required this.productId,
    required this.name,
    required this.type,
    required this.enableStock,
    required this.enableSrNo,
    this.productImage,
    this.productActualName,
    this.productVariationName,
    required this.isDummy,
    this.variationName,
    required this.variationId,
    required this.subSku,
    this.barcodeType,
    required this.quantityAvailable,
    this.formattedQuantityAvailable,
    required this.isAvailable,
    required this.sellingPrice,
    required this.unitPriceBeforeDiscount,
    required this.sellPriceIncTax,
    this.lastPurchasedPrice,
    required this.unit,
    this.unitId,
    required this.unitAllowDecimal,
    this.secondUnit,
    required this.secondaryUnitQuantity,
    this.subUnitId,
    this.taxId,
    required this.itemTax,
    required this.belongsToKitchen,
    this.brandId,
    this.categoryId,
    this.warrantyId,
    this.brand,
    this.transactionSellLinesId,
    this.id,
    required this.quantityOrdered,
    this.sellLineNote,
    this.parentSellLineId,
    this.lotNoLineId,
    this.lineDiscountType,
    required this.lineDiscountAmount,
    required this.comboVariations,
    required this.media,
    required this.groupPrices,
    required this.lotNumbers,
    required this.modifiersIds,
    required this.warranties,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final double quantityAvailable = _toDouble(json['qty_available']) ?? 0.0;

    final double sellingPrice =
        _toDouble(json['default_sell_price'] ?? json['selling_price']) ?? 0.0;

    final double unitPriceBeforeDiscount =
        _toDouble(json['unit_price_before_discount']) ?? sellingPrice;

    final double sellPriceIncTax =
        _toDouble(json['selling_price_inc_tax']) ?? sellingPrice;

    return Product(
      productId: _toInt(json['product_id']) ?? 0,

      name: json['product_name'] ?? json['name'] ?? '',

      productActualName: json['product_actual_name'],

      type: json['product_type'] ?? json['type'] ?? '',

      enableStock: _toInt(json['enable_stock']) ?? 0,

      enableSrNo: _toInt(json['enable_sr_no']) ?? 0,

      productImage: json['product_image'],

      productVariationName: json['product_variation_name'],

      isDummy: _toInt(json['is_dummy']) ?? 0,

      variationName: json['variation_name'] ?? json['variation'],

      variationId: _toInt(json['variation_id'] ?? json['id']) ?? 0,

      subSku: json['sub_sku'] ?? '',

      barcodeType: json['barcode_type'],

      quantityAvailable: quantityAvailable,

      formattedQuantityAvailable: json['formatted_qty_available'],

      isAvailable: quantityAvailable > 0,

      sellingPrice: sellingPrice,

      unitPriceBeforeDiscount: unitPriceBeforeDiscount,

      sellPriceIncTax: sellPriceIncTax,

      lastPurchasedPrice: _toDouble(json['last_purchased_price']),

      unit: json['unit'] ?? '',

      unitId: _toInt(json['unit_id']),

      unitAllowDecimal: _toInt(json['unit_allow_decimal']) ?? 0,

      secondUnit: json['second_unit'],

      secondaryUnitQuantity: _toDouble(json['secondary_unit_quantity']) ?? 0.0,

      subUnitId: _toInt(json['sub_unit_id']),

      taxId: _toInt(json['tax_id']),

      itemTax: _toDouble(json['item_tax']) ?? 0.0,

      belongsToKitchen: _toInt(json['belongs_to_kitchen']) ?? 0,

      brandId: _toInt(json['brand_id']),

      categoryId: _toInt(json['category_id']),

      warrantyId: _toInt(json['warranty_id']),

      brand: json['brand'],

      transactionSellLinesId: _toInt(json['transaction_sell_lines_id']),

      id: _toInt(json['id']),

      quantityOrdered: _toInt(json['quantity_ordered']) ?? 1,

      sellLineNote: json['sell_line_note'],

      parentSellLineId: _toInt(json['parent_sell_line_id']),

      lotNoLineId: _toInt(json['lot_no_line_id']),

      lineDiscountType: json['line_discount_type'],

      lineDiscountAmount: _toDouble(json['line_discount_amount']) ?? 0.0,

      comboVariations: (json['combo_variations'] as List<dynamic>?) ?? [],

      media: (json['media'] as List<dynamic>?) ?? [],

      groupPrices: (json['group_prices'] as List<dynamic>?) ?? [],

      lotNumbers: (json['lot_numbers'] as List<dynamic>?) ?? [],

      modifiersIds: (json['modifiers_ids'] as List<dynamic>?) ?? [],

      warranties: (json['warranties'] as List<dynamic>?) ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': name,
      'product_actual_name': productActualName,
      'product_type': type,
      'enable_stock': enableStock,
      'enable_sr_no': enableSrNo,
      'product_image': productImage,

      'product_variation_name': productVariationName,
      'is_dummy': isDummy,
      'variation_name': variationName,

      'variation_id': variationId,
      'sub_sku': subSku,
      'barcode_type': barcodeType,

      'qty_available': quantityAvailable,
      'formatted_qty_available': formattedQuantityAvailable,

      'default_sell_price': sellingPrice,
      'unit_price_before_discount': unitPriceBeforeDiscount,
      'sell_price_inc_tax': sellPriceIncTax,
      'last_purchased_price': lastPurchasedPrice,

      'unit': unit,
      'unit_id': unitId,
      'unit_allow_decimal': unitAllowDecimal,

      'second_unit': secondUnit,
      'secondary_unit_quantity': secondaryUnitQuantity,
      'sub_unit_id': subUnitId,

      'tax_id': taxId,
      'item_tax': itemTax,

      'belongs_to_kitchen': belongsToKitchen,

      'brand_id': brandId,
      'category_id': categoryId,
      'warranty_id': warrantyId,
      'brand': brand,

      'transaction_sell_lines_id': transactionSellLinesId,

      'id': id,

      'quantity_ordered': quantityOrdered,

      'sell_line_note': sellLineNote,

      'parent_sell_line_id': parentSellLineId,

      'lot_no_line_id': lotNoLineId,

      'line_discount_type': lineDiscountType,

      'line_discount_amount': lineDiscountAmount,

      'combo_variations': comboVariations,

      'media': media,

      'group_prices': groupPrices,

      'lot_numbers': lotNumbers,

      'modifiers_ids': modifiersIds,

      'warranties': warranties,
    };
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return double.tryParse(value.toString())?.toInt();
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: Product._toInt(json['current_page']) ?? 1,
      lastPage: Product._toInt(json['last_page']) ?? 1,
      perPage: Product._toInt(json['per_page']) ?? 50,
      total: Product._toInt(json['total']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}

class CartItem {
  final Product product;

  int quantity;

  int oldQuantity;
  // Product tax information
  int? taxId;

  double itemTax;

  double unitPriceIncTax;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.taxId,
    this.itemTax = 0.0,
    this.oldQuantity = 0,
    double? unitPriceIncTax,
  }) : unitPriceIncTax = unitPriceIncTax ?? product.sellPriceIncTax;

  /// Price before tax × quantity
  double get subtotal => product.sellingPrice * quantity;

  /// Tax per unit × quantity
  double get taxTotal => itemTax * quantity;

  /// Total including tax
  double get total => unitPriceIncTax * quantity;

  Map<String, dynamic> toSellPosJson() {
    return {
      'product_id': product.productId,

      'variation_id': product.variationId,

      'quantity': quantity,

      // Price before tax
      'unit_price': product.sellingPrice,

      // Price including tax
      'unit_price_inc_tax': unitPriceIncTax,

      // Tax per unit
      'item_tax': itemTax,

      // Product tax ID
      'tax_id': taxId,

      'enable_stock': product.enableStock,

      'product_type': product.type,
    };
  }
}

// class ProductTaxData {
//   final int? taxId;
//   final double taxRate;

//   /// Tax amount for ONE unit.
//   final double taxAmount;

//   /// Price without tax.
//   final double unitPrice;

//   /// Price including tax.
//   final double unitPriceIncTax;

//   const ProductTaxData({
//     required this.taxId,
//     required this.taxRate,
//     required this.taxAmount,
//     required this.unitPrice,
//     required this.unitPriceIncTax,
//   });

//   @override
//   String toString() {
//     return 'ProductTaxData('
//         'taxId: $taxId, '
//         'taxRate: $taxRate, '
//         'taxAmount: $taxAmount, '
//         'unitPrice: $unitPrice, '
//         'unitPriceIncTax: $unitPriceIncTax'
//         ')';
//   }
// }
