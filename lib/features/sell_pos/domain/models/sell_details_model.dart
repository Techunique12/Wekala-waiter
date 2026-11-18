import 'package:wekala_waiter/features/customer/domain/models/customer_model.dart';
import 'package:wekala_waiter/features/products/domain/models/products_model.dart';

class SellDetailsModel {
  final bool success;
  final String? message;
  final SellDetailsData? data;

  SellDetailsModel({required this.success, this.message, this.data});

  factory SellDetailsModel.fromJson(Map<String, dynamic> json) {
    return SellDetailsModel(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? SellDetailsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class SellDetailsData {
  final BusinessDetails? businessDetails;
  final Taxes? taxes;
  final Map<String, dynamic> paymentTypes;
  final Customer? walkInCustomer;

  /// Same Product model used in Products API
  final List<Product> sellDetails;

  final Transaction? transaction;
  final List<PaymentLine> paymentLines;
  final Shortcuts? shortcuts;
  final List<dynamic> commissionAgent;
  final List<Category> categories;
  final PosSettings? posSettings;
  final PaymentLine? changeReturn;

  final Map<String, dynamic> types;
  final Map<String, dynamic> customerGroups;
  final Map<String, dynamic> brands;
  final Map<String, dynamic> accounts;

  final List<dynamic> waiters;
  final List<dynamic> redeemDetails;

  final bool editPrice;
  final bool editDiscount;

  final Map<String, dynamic> shippingStatuses;
  final List<dynamic> warranties;

  final Map<String, dynamic> invoiceSchemes;
  final InvoiceScheme? defaultInvoiceSchemes;
  final Map<String, dynamic> invoiceLayouts;

  final List<dynamic> featuredProducts;
  final double customerDue;
  final Map<String, String> users;

  SellDetailsData({
    this.businessDetails,
    this.taxes,
    required this.paymentTypes,
    this.walkInCustomer,
    required this.sellDetails,
    this.transaction,
    required this.paymentLines,
    this.shortcuts,
    required this.commissionAgent,
    required this.categories,
    this.posSettings,
    this.changeReturn,
    required this.types,
    required this.customerGroups,
    required this.brands,
    required this.accounts,
    required this.waiters,
    required this.redeemDetails,
    required this.editPrice,
    required this.editDiscount,
    required this.shippingStatuses,
    required this.warranties,
    required this.invoiceSchemes,
    this.defaultInvoiceSchemes,
    required this.invoiceLayouts,
    required this.featuredProducts,
    required this.customerDue,
    required this.users,
  });

  factory SellDetailsData.fromJson(Map<String, dynamic> json) {
    return SellDetailsData(
      businessDetails: json['business_details'] != null
          ? BusinessDetails.fromJson(json['business_details'])
          : null,
      taxes: json['taxes'] != null ? Taxes.fromJson(json['taxes']) : null,
      paymentTypes: Map<String, dynamic>.from(json['payment_types'] ?? {}),
      walkInCustomer: json['walk_in_customer'] != null
          ? Customer.fromJson(json['walk_in_customer'])
          : null,

      // IMPORTANT:
      // sell_details uses the same Product model
      sellDetails:
          (json['sell_details'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],

      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,

      paymentLines:
          (json['payment_lines'] as List<dynamic>?)
              ?.map((e) => PaymentLine.fromJson(e))
              .toList() ??
          [],

      shortcuts: json['shortcuts'] != null
          ? Shortcuts.fromJson(json['shortcuts'])
          : null,

      commissionAgent: (json['commission_agent'] as List<dynamic>?) ?? [],

      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e))
              .toList() ??
          [],

      posSettings: json['pos_settings'] != null
          ? PosSettings.fromJson(json['pos_settings'])
          : null,

      changeReturn: json['change_return'] != null
          ? PaymentLine.fromJson(json['change_return'])
          : null,

      types: Map<String, dynamic>.from(json['types'] ?? {}),
      customerGroups: Map<String, dynamic>.from(json['customer_groups'] ?? {}),
      brands: Map<String, dynamic>.from(json['brands'] ?? {}),
      accounts: Map<String, dynamic>.from(json['accounts'] ?? {}),

      waiters: (json['waiters'] as List<dynamic>?) ?? [],
      redeemDetails: (json['redeem_details'] as List<dynamic>?) ?? [],

      editPrice: json['edit_price'] ?? false,
      editDiscount: json['edit_discount'] ?? false,

      shippingStatuses: Map<String, dynamic>.from(
        json['shipping_statuses'] ?? {},
      ),

      warranties: (json['warranties'] as List<dynamic>?) ?? [],

      invoiceSchemes: Map<String, dynamic>.from(json['invoice_schemes'] ?? {}),

      defaultInvoiceSchemes: json['default_invoice_schemes'] != null
          ? InvoiceScheme.fromJson(json['default_invoice_schemes'])
          : null,

      invoiceLayouts: Map<String, dynamic>.from(json['invoice_layouts'] ?? {}),

      featuredProducts: (json['featured_products'] as List<dynamic>?) ?? [],

      customerDue:
          double.tryParse(json['customer_due']?.toString() ?? '') ?? 0.0,

      users: (json['users'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_details': businessDetails?.toJson(),
      'taxes': taxes?.toJson(),
      'payment_types': paymentTypes,
      'walk_in_customer': walkInCustomer?.toJson(),
      'sell_details': sellDetails.map((e) => e.toJson()).toList(),
      'transaction': transaction?.toJson(),
      'payment_lines': paymentLines.map((e) => e.toJson()).toList(),
      'shortcuts': shortcuts?.toJson(),
      'commission_agent': commissionAgent,
      'categories': categories.map((e) => e.toJson()).toList(),
      'pos_settings': posSettings?.toJson(),
      'change_return': changeReturn?.toJson(),
      'types': types,
      'customer_groups': customerGroups,
      'brands': brands,
      'accounts': accounts,
      'waiters': waiters,
      'redeem_details': redeemDetails,
      'edit_price': editPrice,
      'edit_discount': editDiscount,
      'shipping_statuses': shippingStatuses,
      'warranties': warranties,
      'invoice_schemes': invoiceSchemes,
      'default_invoice_schemes': defaultInvoiceSchemes?.toJson(),
      'invoice_layouts': invoiceLayouts,
      'featured_products': featuredProducts,
      'customer_due': customerDue,
      'users': users,
    };
  }
}

// ============================================================
// PRODUCT
// ============================================================

// ============================================================
// BUSINESS DETAILS
// ============================================================

class BusinessDetails {
  final int id;
  final String name;
  final int? currencyId;
  final String? startDate;
  final String? timeZone;
  final String? accountingMethod;
  final double defaultProfitPercent;
  final String? defaultSalesDiscount;
  final String? sellPriceTax;
  final String? currencyCode;
  final String? currencySymbol;
  final String? thousandSeparator;
  final String? decimalSeparator;
  final int currencyPrecision;
  final int quantityPrecision;
  final String? themeColor;
  final int isActive;
  final String? accountStatus;

  BusinessDetails({
    required this.id,
    required this.name,
    this.currencyId,
    this.startDate,
    this.timeZone,
    this.accountingMethod,
    required this.defaultProfitPercent,
    this.defaultSalesDiscount,
    this.sellPriceTax,
    this.currencyCode,
    this.currencySymbol,
    this.thousandSeparator,
    this.decimalSeparator,
    required this.currencyPrecision,
    required this.quantityPrecision,
    this.themeColor,
    required this.isActive,
    this.accountStatus,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      currencyId: json['currency_id'],
      startDate: json['start_date'],
      timeZone: json['time_zone'],
      accountingMethod: json['accounting_method'],
      defaultProfitPercent:
          double.tryParse(json['default_profit_percent']?.toString() ?? '') ??
          0.0,
      defaultSalesDiscount: json['default_sales_discount'],
      sellPriceTax: json['sell_price_tax'],
      currencyCode: json['currency_code'],
      currencySymbol: json['currency_symbol'],
      thousandSeparator: json['thousand_separator'],
      decimalSeparator: json['decimal_separator'],
      currencyPrecision: json['currency_precision'] ?? 2,
      quantityPrecision: json['quantity_precision'] ?? 2,
      themeColor: json['theme_color'],
      isActive: json['is_active'] ?? 0,
      accountStatus: json['account_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currency_id': currencyId,
      'start_date': startDate,
      'time_zone': timeZone,
      'accounting_method': accountingMethod,
      'default_profit_percent': defaultProfitPercent,
      'default_sales_discount': defaultSalesDiscount,
      'sell_price_tax': sellPriceTax,
      'currency_code': currencyCode,
      'currency_symbol': currencySymbol,
      'thousand_separator': thousandSeparator,
      'decimal_separator': decimalSeparator,
      'currency_precision': currencyPrecision,
      'quantity_precision': quantityPrecision,
      'theme_color': themeColor,
      'is_active': isActive,
      'account_status': accountStatus,
    };
  }
}

// ============================================================
// TAXES
// ============================================================

class Taxes {
  final Map<String, dynamic> taxRates;
  final Map<String, dynamic> attributes;

  Taxes({required this.taxRates, required this.attributes});

  factory Taxes.fromJson(Map<String, dynamic> json) {
    return Taxes(
      taxRates: Map<String, dynamic>.from(json['tax_rates'] ?? {}),
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'tax_rates': taxRates, 'attributes': attributes};
  }
}

// ============================================================
// WALK IN CUSTOMER
// ============================================================

// ============================================================
// TRANSACTION
// ============================================================

class Transaction {
  final int id;
  final int businessId;
  final int locationId;
  final int? resTableId;
  final String? type;
  final String? status;
  final int? contactId;
  final String? invoiceNo;
  final int? queueNo;
  final String? refNo;
  final String? transactionDate;

  final double totalBeforeTax;
  final int? taxId;
  final double taxAmount;

  final String? discountType;
  final double discountAmount;

  final double rpRedeemedAmount;
  final double shippingCharges;
  final double roundOffAmount;
  final double finalTotal;

  final int isDirectSale;
  final int isSuspend;

  final double exchangeRate;

  final int? createdBy;
  final int? typesOfServiceId;

  final String? packingCharge;
  final String? packingChargeType;

  final int isCreatedFromApi;
  final int rpEarned;

  final String? createdAt;
  final String? updatedAt;

  final String? paidStatus;
  final TypesOfService? typesOfService;

  final String? additionalNotes;

  Transaction({
    required this.id,
    required this.businessId,
    required this.locationId,
    this.resTableId,
    this.type,
    this.status,
    this.contactId,
    this.invoiceNo,
    this.queueNo,
    this.refNo,
    this.transactionDate,
    required this.totalBeforeTax,
    this.taxId,
    required this.taxAmount,
    this.discountType,
    required this.discountAmount,
    required this.rpRedeemedAmount,
    required this.shippingCharges,
    required this.roundOffAmount,
    required this.finalTotal,
    required this.isDirectSale,
    required this.isSuspend,
    required this.exchangeRate,
    this.createdBy,
    this.typesOfServiceId,
    this.packingCharge,
    this.packingChargeType,
    required this.isCreatedFromApi,
    required this.rpEarned,
    this.createdAt,
    this.updatedAt,
    this.paidStatus,
    this.typesOfService,
    this.additionalNotes,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      businessId: json['business_id'] ?? 0,
      locationId: json['location_id'] ?? 0,
      resTableId: json['res_table_id'],
      type: json['type'],
      status: json['status'],
      contactId: json['contact_id'],
      invoiceNo: json['invoice_no'],
      queueNo: json['queue_no'],
      refNo: json['ref_no'],
      transactionDate: json['transaction_date'],
      totalBeforeTax:
          double.tryParse(json['total_before_tax']?.toString() ?? '') ?? 0.0,
      taxId: json['tax_id'],
      taxAmount: double.tryParse(json['tax_amount']?.toString() ?? '') ?? 0.0,
      discountType: json['discount_type'],
      discountAmount:
          double.tryParse(json['discount_amount']?.toString() ?? '') ?? 0.0,
      rpRedeemedAmount:
          double.tryParse(json['rp_redeemed_amount']?.toString() ?? '') ?? 0.0,
      shippingCharges:
          double.tryParse(json['shipping_charges']?.toString() ?? '') ?? 0.0,
      roundOffAmount:
          double.tryParse(json['round_off_amount']?.toString() ?? '') ?? 0.0,
      finalTotal: double.tryParse(json['final_total']?.toString() ?? '') ?? 0.0,
      isDirectSale: json['is_direct_sale'] ?? 0,
      isSuspend: json['is_suspend'] ?? 0,
      exchangeRate:
          double.tryParse(json['exchange_rate']?.toString() ?? '') ?? 1.0,
      createdBy: json['created_by'],
      typesOfServiceId: json['types_of_service_id'],
      packingCharge: json['packing_charge']?.toString(),
      packingChargeType: json['packing_charge_type'],
      isCreatedFromApi: json['is_created_from_api'] ?? 0,
      rpEarned: json['rp_earned'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      paidStatus: json['paid_status'],
      typesOfService: json['types_of_service'] != null
          ? TypesOfService.fromJson(json['types_of_service'])
          : null,
      additionalNotes: json['additional_notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'location_id': locationId,
      'res_table_id': resTableId,
      'type': type,
      'status': status,
      'contact_id': contactId,
      'invoice_no': invoiceNo,
      'queue_no': queueNo,
      'ref_no': refNo,
      'transaction_date': transactionDate,
      'total_before_tax': totalBeforeTax,
      'tax_id': taxId,
      'tax_amount': taxAmount,
      'discount_type': discountType,
      'discount_amount': discountAmount,
      'rp_redeemed_amount': rpRedeemedAmount,
      'shipping_charges': shippingCharges,
      'round_off_amount': roundOffAmount,
      'final_total': finalTotal,
      'is_direct_sale': isDirectSale,
      'is_suspend': isSuspend,
      'exchange_rate': exchangeRate,
      'created_by': createdBy,
      'types_of_service_id': typesOfServiceId,
      'packing_charge': packingCharge,
      'packing_charge_type': packingChargeType,
      'is_created_from_api': isCreatedFromApi,
      'rp_earned': rpEarned,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'paid_status': paidStatus,
      'types_of_service': typesOfService?.toJson(),
    };
  }
}

// ============================================================
// TYPES OF SERVICE
// ============================================================

class TypesOfService {
  final int id;
  final String name;
  final String? icon;
  final int requiresTable;
  final String? description;

  TypesOfService({
    required this.id,
    required this.name,
    this.icon,
    required this.requiresTable,
    this.description,
  });

  factory TypesOfService.fromJson(Map<String, dynamic> json) {
    return TypesOfService(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'],
      requiresTable: json['requires_table'] ?? 0,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'requires_table': requiresTable,
      'description': description,
    };
  }
}

// ============================================================
// PAYMENT LINE
// ============================================================

class PaymentLine {
  final String method;
  final double amount;
  final String note;
  final String cardTransactionNumber;
  final String cardNumber;
  final String cardType;
  final String cardHolderName;
  final String cardMonth;
  final String cardYear;
  final String cardSecurity;
  final String chequeNumber;
  final String bankAccountNumber;
  final int isReturn;
  final String transactionNo;

  PaymentLine({
    required this.method,
    required this.amount,
    required this.note,
    required this.cardTransactionNumber,
    required this.cardNumber,
    required this.cardType,
    required this.cardHolderName,
    required this.cardMonth,
    required this.cardYear,
    required this.cardSecurity,
    required this.chequeNumber,
    required this.bankAccountNumber,
    required this.isReturn,
    required this.transactionNo,
  });

  factory PaymentLine.fromJson(Map<String, dynamic> json) {
    return PaymentLine(
      method: json['method'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0.0,
      note: json['note'] ?? '',
      cardTransactionNumber: json['card_transaction_number'] ?? '',
      cardNumber: json['card_number'] ?? '',
      cardType: json['card_type'] ?? '',
      cardHolderName: json['card_holder_name'] ?? '',
      cardMonth: json['card_month'] ?? '',
      cardYear: json['card_year'] ?? '',
      cardSecurity: json['card_security'] ?? '',
      chequeNumber: json['cheque_number'] ?? '',
      bankAccountNumber: json['bank_account_number'] ?? '',
      isReturn: json['is_return'] ?? 0,
      transactionNo: json['transaction_no'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'amount': amount,
      'note': note,
      'card_transaction_number': cardTransactionNumber,
      'card_number': cardNumber,
      'card_type': cardType,
      'card_holder_name': cardHolderName,
      'card_month': cardMonth,
      'card_year': cardYear,
      'card_security': cardSecurity,
      'cheque_number': chequeNumber,
      'bank_account_number': bankAccountNumber,
      'is_return': isReturn,
      'transaction_no': transactionNo,
    };
  }
}

// ============================================================
// SHORTCUTS
// ============================================================

class Shortcuts {
  final PosShortcuts? pos;

  Shortcuts({this.pos});

  factory Shortcuts.fromJson(Map<String, dynamic> json) {
    return Shortcuts(
      pos: json['pos'] != null ? PosShortcuts.fromJson(json['pos']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'pos': pos?.toJson()};
  }
}

class PosShortcuts {
  final String? expressCheckout;
  final String? payNCheckout;
  final String? draft;
  final String? cancel;
  final String? recentProductQuantity;
  final String? weighingScale;
  final String? editDiscount;
  final String? editOrderTax;
  final String? addPaymentRow;
  final String? finalizePayment;
  final String? addNewProduct;

  PosShortcuts({
    this.expressCheckout,
    this.payNCheckout,
    this.draft,
    this.cancel,
    this.recentProductQuantity,
    this.weighingScale,
    this.editDiscount,
    this.editOrderTax,
    this.addPaymentRow,
    this.finalizePayment,
    this.addNewProduct,
  });

  factory PosShortcuts.fromJson(Map<String, dynamic> json) {
    return PosShortcuts(
      expressCheckout: json['express_checkout'],
      payNCheckout: json['pay_n_ckeckout'],
      draft: json['draft'],
      cancel: json['cancel'],
      recentProductQuantity: json['recent_product_quantity'],
      weighingScale: json['weighing_scale'],
      editDiscount: json['edit_discount'],
      editOrderTax: json['edit_order_tax'],
      addPaymentRow: json['add_payment_row'],
      finalizePayment: json['finalize_payment'],
      addNewProduct: json['add_new_product'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'express_checkout': expressCheckout,
      'pay_n_ckeckout': payNCheckout,
      'draft': draft,
      'cancel': cancel,
      'recent_product_quantity': recentProductQuantity,
      'weighing_scale': weighingScale,
      'edit_discount': editDiscount,
      'edit_order_tax': editOrderTax,
      'add_payment_row': addPaymentRow,
      'finalize_payment': finalizePayment,
      'add_new_product': addNewProduct,
    };
  }
}

// ============================================================
// CATEGORY
// ============================================================

class Category {
  final int id;
  final String name;
  final int businessId;
  final String? shortCode;
  final int parentId;
  final int? createdBy;
  final String? categoryType;
  final int? kitchenTypeId;
  final int belongsToKitchen;

  Category({
    required this.id,
    required this.name,
    required this.businessId,
    this.shortCode,
    required this.parentId,
    this.createdBy,
    this.categoryType,
    this.kitchenTypeId,
    required this.belongsToKitchen,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      businessId: json['business_id'] ?? 0,
      shortCode: json['short_code'],
      parentId: json['parent_id'] ?? 0,
      createdBy: json['created_by'],
      categoryType: json['category_type'],
      kitchenTypeId: json['kitchen_type_id'],
      belongsToKitchen: json['belongs_to_kitchen'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_id': businessId,
      'short_code': shortCode,
      'parent_id': parentId,
      'created_by': createdBy,
      'category_type': categoryType,
      'kitchen_type_id': kitchenTypeId,
      'belongs_to_kitchen': belongsToKitchen,
    };
  }
}

// ============================================================
// POS SETTINGS
// ============================================================

class PosSettings {
  final String? amountRoundingMethod;
  final String? enableMsp;
  final String? cmmsnCalculationType;

  final String? razorPayKeyId;
  final String? razorPayKeySecret;
  final String? stripePublicKey;
  final String? stripeSecretKey;

  final String? isPosSubtotalEditable;
  final String? isServiceStaffRequired;

  final dynamic cashDenominations;
  final String? enableCashDenominationOn;

  final int disablePayCheckout;
  final int disableDraft;
  final int disableExpressCheckout;
  final int hideProductSuggestion;
  final int hideRecentTrans;
  final int disableDiscount;
  final int disableOrderTax;

  PosSettings({
    this.amountRoundingMethod,
    this.enableMsp,
    this.cmmsnCalculationType,
    this.razorPayKeyId,
    this.razorPayKeySecret,
    this.stripePublicKey,
    this.stripeSecretKey,
    this.isPosSubtotalEditable,
    this.isServiceStaffRequired,
    this.cashDenominations,
    this.enableCashDenominationOn,
    required this.disablePayCheckout,
    required this.disableDraft,
    required this.disableExpressCheckout,
    required this.hideProductSuggestion,
    required this.hideRecentTrans,
    required this.disableDiscount,
    required this.disableOrderTax,
  });

  factory PosSettings.fromJson(Map<String, dynamic> json) {
    return PosSettings(
      amountRoundingMethod: json['amount_rounding_method']?.toString(),
      enableMsp: json['enable_msp']?.toString(),
      cmmsnCalculationType: json['cmmsn_calculation_type']?.toString(),
      razorPayKeyId: json['razor_pay_key_id']?.toString(),
      razorPayKeySecret: json['razor_pay_key_secret']?.toString(),
      stripePublicKey: json['stripe_public_key']?.toString(),
      stripeSecretKey: json['stripe_secret_key']?.toString(),
      isPosSubtotalEditable: json['is_pos_subtotal_editable']?.toString(),
      isServiceStaffRequired: json['is_service_staff_required']?.toString(),
      cashDenominations: json['cash_denominations'],
      enableCashDenominationOn: json['enable_cash_denomination_on']?.toString(),
      disablePayCheckout: json['disable_pay_checkout'] ?? 0,
      disableDraft: json['disable_draft'] ?? 0,
      disableExpressCheckout: json['disable_express_checkout'] ?? 0,
      hideProductSuggestion: json['hide_product_suggestion'] ?? 0,
      hideRecentTrans: json['hide_recent_trans'] ?? 0,
      disableDiscount: json['disable_discount'] ?? 0,
      disableOrderTax: json['disable_order_tax'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount_rounding_method': amountRoundingMethod,
      'enable_msp': enableMsp,
      'cmmsn_calculation_type': cmmsnCalculationType,
      'razor_pay_key_id': razorPayKeyId,
      'razor_pay_key_secret': razorPayKeySecret,
      'stripe_public_key': stripePublicKey,
      'stripe_secret_key': stripeSecretKey,
      'is_pos_subtotal_editable': isPosSubtotalEditable,
      'is_service_staff_required': isServiceStaffRequired,
      'cash_denominations': cashDenominations,
      'enable_cash_denomination_on': enableCashDenominationOn,
      'disable_pay_checkout': disablePayCheckout,
      'disable_draft': disableDraft,
      'disable_express_checkout': disableExpressCheckout,
      'hide_product_suggestion': hideProductSuggestion,
      'hide_recent_trans': hideRecentTrans,
      'disable_discount': disableDiscount,
      'disable_order_tax': disableOrderTax,
    };
  }
}

// ============================================================
// INVOICE SCHEME
// ============================================================

class InvoiceScheme {
  final int id;
  final int businessId;
  final String name;
  final String? schemeType;
  final String? numberType;
  final String? prefix;
  final int startNumber;
  final int invoiceCount;
  final int totalDigits;
  final int isDefault;

  InvoiceScheme({
    required this.id,
    required this.businessId,
    required this.name,
    this.schemeType,
    this.numberType,
    this.prefix,
    required this.startNumber,
    required this.invoiceCount,
    required this.totalDigits,
    required this.isDefault,
  });

  factory InvoiceScheme.fromJson(Map<String, dynamic> json) {
    return InvoiceScheme(
      id: json['id'] ?? 0,
      businessId: json['business_id'] ?? 0,
      name: json['name'] ?? '',
      schemeType: json['scheme_type'],
      numberType: json['number_type'],
      prefix: json['prefix'],
      startNumber: json['start_number'] ?? 1,
      invoiceCount: json['invoice_count'] ?? 0,
      totalDigits: json['total_digits'] ?? 0,
      isDefault: json['is_default'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'name': name,
      'scheme_type': schemeType,
      'number_type': numberType,
      'prefix': prefix,
      'start_number': startNumber,
      'invoice_count': invoiceCount,
      'total_digits': totalDigits,
      'is_default': isDefault,
    };
  }
}
