class RegisterCloseDataResponse {
  final bool success;
  final String? message;
  final RegisterDataModel? data;

  RegisterCloseDataResponse({required this.success, this.message, this.data});

  factory RegisterCloseDataResponse.fromJson(Map<String, dynamic> json) {
    return RegisterCloseDataResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? RegisterDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class RegisterDataModel {
  final RegisterDetailsModel? registerDetails;
  final RegisterDetailsDataModel? details;
  final PaymentTypesModel? paymentTypes;
  final PosSettingsModel? posSettings;

  RegisterDataModel({
    this.registerDetails,
    this.details,
    this.paymentTypes,
    this.posSettings,
  });

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterDataModel(
      registerDetails: json['register_details'] != null
          ? RegisterDetailsModel.fromJson(json['register_details'])
          : null,
      details: json['details'] != null
          ? RegisterDetailsDataModel.fromJson(json['details'])
          : null,
      paymentTypes: json['payment_types'] != null
          ? PaymentTypesModel.fromJson(json['payment_types'])
          : null,
      posSettings: json['pos_settings'] != null
          ? PosSettingsModel.fromJson(json['pos_settings'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'register_details': registerDetails?.toJson(),
      'details': details?.toJson(),
      'payment_types': paymentTypes?.toJson(),
      'pos_settings': posSettings?.toJson(),
    };
  }
}

class RegisterDetailsModel {
  final int? id;
  final String? status;
  final double closingAmount;
  final DateTime? openTime;
  final DateTime? closedAt;
  final int? userId;
  final String? closingNote;
  final int? locationId;
  final dynamic denominations;

  final double cashInHand;
  final double totalSale;
  final double totalExpense;
  final double totalCash;
  final double totalCashExpense;

  final double totalCheque;
  final double totalChequeExpense;
  final double totalCard;
  final double totalCardExpense;

  final double totalBankTransfer;
  final double totalBankTransferExpense;
  final double totalOther;
  final double totalOtherExpense;

  final double totalAdvance;
  final double totalAdvanceExpense;

  final double totalCustomPay1;
  final double totalCustomPay2;
  final double totalCustomPay3;
  final double totalCustomPay4;
  final double totalCustomPay5;
  final double totalCustomPay6;
  final double totalCustomPay7;

  final double totalCustomPay1Expense;
  final double totalCustomPay2Expense;
  final double totalCustomPay3Expense;
  final double totalCustomPay4Expense;
  final double totalCustomPay5Expense;
  final double totalCustomPay6Expense;
  final double totalCustomPay7Expense;

  final double totalRefund;
  final double totalCashRefund;
  final double totalChequeRefund;
  final double totalCardRefund;
  final double totalBankTransferRefund;
  final double totalOtherRefund;
  final double totalAdvanceRefund;

  final double totalCustomPay1Refund;
  final double totalCustomPay2Refund;
  final double totalCustomPay3Refund;
  final double totalCustomPay4Refund;
  final double totalCustomPay5Refund;
  final double totalCustomPay6Refund;
  final double totalCustomPay7Refund;

  final int totalCheques;
  final int totalCardSlips;

  final String? userName;
  final String? email;
  final String? locationName;

  RegisterDetailsModel({
    this.id,
    this.status,
    required this.closingAmount,
    this.openTime,
    this.closedAt,
    this.userId,
    this.closingNote,
    this.locationId,
    this.denominations,
    this.cashInHand = 0,
    this.totalSale = 0,
    this.totalExpense = 0,
    this.totalCash = 0,
    this.totalCashExpense = 0,
    this.totalCheque = 0,
    this.totalChequeExpense = 0,
    this.totalCard = 0,
    this.totalCardExpense = 0,
    this.totalBankTransfer = 0,
    this.totalBankTransferExpense = 0,
    this.totalOther = 0,
    this.totalOtherExpense = 0,
    this.totalAdvance = 0,
    this.totalAdvanceExpense = 0,
    this.totalCustomPay1 = 0,
    this.totalCustomPay2 = 0,
    this.totalCustomPay3 = 0,
    this.totalCustomPay4 = 0,
    this.totalCustomPay5 = 0,
    this.totalCustomPay6 = 0,
    this.totalCustomPay7 = 0,
    this.totalCustomPay1Expense = 0,
    this.totalCustomPay2Expense = 0,
    this.totalCustomPay3Expense = 0,
    this.totalCustomPay4Expense = 0,
    this.totalCustomPay5Expense = 0,
    this.totalCustomPay6Expense = 0,
    this.totalCustomPay7Expense = 0,
    this.totalRefund = 0,
    this.totalCashRefund = 0,
    this.totalChequeRefund = 0,
    this.totalCardRefund = 0,
    this.totalBankTransferRefund = 0,
    this.totalOtherRefund = 0,
    this.totalAdvanceRefund = 0,
    this.totalCustomPay1Refund = 0,
    this.totalCustomPay2Refund = 0,
    this.totalCustomPay3Refund = 0,
    this.totalCustomPay4Refund = 0,
    this.totalCustomPay5Refund = 0,
    this.totalCustomPay6Refund = 0,
    this.totalCustomPay7Refund = 0,
    this.totalCheques = 0,
    this.totalCardSlips = 0,
    this.userName,
    this.email,
    this.locationName,
  });

  factory RegisterDetailsModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    int toInt(dynamic value) {
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return RegisterDetailsModel(
      id: toInt(json['id']),
      status: json['status'],
      closingAmount: toDouble(json['closing_amount']),
      openTime: json['open_time'] != null
          ? DateTime.tryParse(json['open_time'])
          : null,
      closedAt: json['closed_at'] != null
          ? DateTime.tryParse(json['closed_at'])
          : null,
      userId: toInt(json['user_id']),
      closingNote: json['closing_note'],
      locationId: toInt(json['location_id']),
      denominations: json['denominations'],

      cashInHand: toDouble(json['cash_in_hand']),
      totalSale: toDouble(json['total_sale']),
      totalExpense: toDouble(json['total_expense']),
      totalCash: toDouble(json['total_cash']),
      totalCashExpense: toDouble(json['total_cash_expense']),

      totalCheque: toDouble(json['total_cheque']),
      totalChequeExpense: toDouble(json['total_cheque_expense']),
      totalCard: toDouble(json['total_card']),
      totalCardExpense: toDouble(json['total_card_expense']),

      totalBankTransfer: toDouble(json['total_bank_transfer']),
      totalBankTransferExpense: toDouble(json['total_bank_transfer_expense']),
      totalOther: toDouble(json['total_other']),
      totalOtherExpense: toDouble(json['total_other_expense']),

      totalAdvance: toDouble(json['total_advance']),
      totalAdvanceExpense: toDouble(json['total_advance_expense']),

      totalCustomPay1: toDouble(json['total_custom_pay_1']),
      totalCustomPay2: toDouble(json['total_custom_pay_2']),
      totalCustomPay3: toDouble(json['total_custom_pay_3']),
      totalCustomPay4: toDouble(json['total_custom_pay_4']),
      totalCustomPay5: toDouble(json['total_custom_pay_5']),
      totalCustomPay6: toDouble(json['total_custom_pay_6']),
      totalCustomPay7: toDouble(json['total_custom_pay_7']),

      totalCustomPay1Expense: toDouble(json['total_custom_pay_1_expense']),
      totalCustomPay2Expense: toDouble(json['total_custom_pay_2_expense']),
      totalCustomPay3Expense: toDouble(json['total_custom_pay_3_expense']),
      totalCustomPay4Expense: toDouble(json['total_custom_pay_4_expense']),
      totalCustomPay5Expense: toDouble(json['total_custom_pay_5_expense']),
      totalCustomPay6Expense: toDouble(json['total_custom_pay_6_expense']),
      totalCustomPay7Expense: toDouble(json['total_custom_pay_7_expense']),

      totalRefund: toDouble(json['total_refund']),
      totalCashRefund: toDouble(json['total_cash_refund']),
      totalChequeRefund: toDouble(json['total_cheque_refund']),
      totalCardRefund: toDouble(json['total_card_refund']),
      totalBankTransferRefund: toDouble(json['total_bank_transfer_refund']),
      totalOtherRefund: toDouble(json['total_other_refund']),
      totalAdvanceRefund: toDouble(json['total_advance_refund']),

      totalCustomPay1Refund: toDouble(json['total_custom_pay_1_refund']),
      totalCustomPay2Refund: toDouble(json['total_custom_pay_2_refund']),
      totalCustomPay3Refund: toDouble(json['total_custom_pay_3_refund']),
      totalCustomPay4Refund: toDouble(json['total_custom_pay_4_refund']),
      totalCustomPay5Refund: toDouble(json['total_custom_pay_5_refund']),
      totalCustomPay6Refund: toDouble(json['total_custom_pay_6_refund']),
      totalCustomPay7Refund: toDouble(json['total_custom_pay_7_refund']),

      totalCheques: toInt(json['total_cheques']),
      totalCardSlips: toInt(json['total_card_slips']),

      userName: json['user_name'],
      email: json['email'],
      locationName: json['location_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open_time': openTime,
      'closed_at': closedAt,
      'user_id': userId,
      'closing_note': closingNote,
      'location_id': locationId,
      'denominations': denominations,
      'cash_in_hand': cashInHand,
      'total_sale': totalSale,
      'total_expense': totalExpense,
      'total_cash': totalCash,
      'total_cash_expense': totalCashExpense,
      'total_cheque': totalCheque,
      'total_cheque_expense': totalChequeExpense,
      'total_card': totalCard,
      'total_card_expense': totalCardExpense,
      'total_bank_transfer': totalBankTransfer,
      'total_bank_transfer_expense': totalBankTransferExpense,
      'total_other': totalOther,
      'total_other_expense': totalOtherExpense,
      'total_advance': totalAdvance,
      'total_advance_expense': totalAdvanceExpense,
      'total_custom_pay_1': totalCustomPay1,
      'total_custom_pay_2': totalCustomPay2,
      'total_custom_pay_3': totalCustomPay3,
      'total_custom_pay_4': totalCustomPay4,
      'total_custom_pay_5': totalCustomPay5,
      'total_custom_pay_6': totalCustomPay6,
      'total_custom_pay_7': totalCustomPay7,
      'total_custom_pay_1_expense': totalCustomPay1Expense,
      'total_custom_pay_2_expense': totalCustomPay2Expense,
      'total_custom_pay_3_expense': totalCustomPay3Expense,
      'total_custom_pay_4_expense': totalCustomPay4Expense,
      'total_custom_pay_5_expense': totalCustomPay5Expense,
      'total_custom_pay_6_expense': totalCustomPay6Expense,
      'total_custom_pay_7_expense': totalCustomPay7Expense,
      'total_refund': totalRefund,
      'total_cash_refund': totalCashRefund,
      'total_cheque_refund': totalChequeRefund,
      'total_card_refund': totalCardRefund,
      'total_bank_transfer_refund': totalBankTransferRefund,
      'total_other_refund': totalOtherRefund,
      'total_advance_refund': totalAdvanceRefund,
      'total_custom_pay_1_refund': totalCustomPay1Refund,
      'total_custom_pay_2_refund': totalCustomPay2Refund,
      'total_custom_pay_3_refund': totalCustomPay3Refund,
      'total_custom_pay_4_refund': totalCustomPay4Refund,
      'total_custom_pay_5_refund': totalCustomPay5Refund,
      'total_custom_pay_6_refund': totalCustomPay6Refund,
      'total_custom_pay_7_refund': totalCustomPay7Refund,
      'total_cheques': totalCheques,
      'total_card_slips': totalCardSlips,
      'user_name': userName,
      'email': email,
      'location_name': locationName,
    };
  }
}

class RegisterDetailsDataModel {
  final List<ProductBrandDetailsModel> productDetailsByBrand;
  final TransactionDetailsModel? transactionDetails;
  final List<ServiceTypeDetailsModel> typesOfServiceDetails;
  final List<ProductDetailsModel> productDetails;

  RegisterDetailsDataModel({
    this.productDetailsByBrand = const [],
    this.transactionDetails,
    this.typesOfServiceDetails = const [],
    this.productDetails = const [],
  });

  factory RegisterDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterDetailsDataModel(
      productDetailsByBrand:
          (json['product_details_by_brand'] as List?)
              ?.map((e) => ProductBrandDetailsModel.fromJson(e))
              .toList() ??
          [],
      transactionDetails: json['transaction_details'] != null
          ? TransactionDetailsModel.fromJson(json['transaction_details'])
          : null,
      typesOfServiceDetails:
          (json['types_of_service_details'] as List?)
              ?.map((e) => ServiceTypeDetailsModel.fromJson(e))
              .toList() ??
          [],
      productDetails:
          (json['product_details'] as List?)
              ?.map((e) => ProductDetailsModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_details_by_brand': productDetailsByBrand
          .map((e) => e.toJson())
          .toList(),
      'transaction_details': transactionDetails?.toJson(),
      'types_of_service_details': typesOfServiceDetails
          .map((e) => e.toJson())
          .toList(),
      'product_details': productDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductBrandDetailsModel {
  final String? brandName;
  final double totalQuantity;
  final double totalAmount;

  ProductBrandDetailsModel({
    this.brandName,
    this.totalQuantity = 0,
    this.totalAmount = 0,
  });

  factory ProductBrandDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductBrandDetailsModel(
      brandName: json['brand_name'],
      totalQuantity:
          double.tryParse(json['total_quantity']?.toString() ?? '') ?? 0,
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand_name': brandName,
      'total_quantity': totalQuantity,
      'total_amount': totalAmount,
    };
  }
}

class TransactionDetailsModel {
  final double totalTax;
  final double totalDiscount;
  final double totalSales;
  final double totalShippingCharges;

  TransactionDetailsModel({
    this.totalTax = 0,
    this.totalDiscount = 0,
    this.totalSales = 0,
    this.totalShippingCharges = 0,
  });

  factory TransactionDetailsModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic value) =>
        double.tryParse(value?.toString() ?? '') ?? 0;

    return TransactionDetailsModel(
      totalTax: parse(json['total_tax']),
      totalDiscount: parse(json['total_discount']),
      totalSales: parse(json['total_sales']),
      totalShippingCharges: parse(json['total_shipping_charges']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_tax': totalTax,
      'total_discount': totalDiscount,
      'total_sales': totalSales,
      'total_shipping_charges': totalShippingCharges,
    };
  }
}

class ServiceTypeDetailsModel {
  final String? typesOfServiceName;
  final double totalSales;

  ServiceTypeDetailsModel({this.typesOfServiceName, this.totalSales = 0});

  factory ServiceTypeDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeDetailsModel(
      typesOfServiceName: json['types_of_service_name'],
      totalSales: double.tryParse(json['total_sales']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'types_of_service_name': typesOfServiceName,
      'total_sales': totalSales,
    };
  }
}

class ProductDetailsModel {
  final String? productName;
  final String? productType;
  final String? variationName;
  final String? productVariationName;
  final String? sku;
  final double totalQuantity;
  final double totalAmount;

  ProductDetailsModel({
    this.productName,
    this.productType,
    this.variationName,
    this.productVariationName,
    this.sku,
    this.totalQuantity = 0,
    this.totalAmount = 0,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic value) =>
        double.tryParse(value?.toString() ?? '') ?? 0;

    return ProductDetailsModel(
      productName: json['product_name'],
      productType: json['product_type'],
      variationName: json['variation_name'],
      productVariationName: json['product_variation_name'],
      sku: json['sku'],
      totalQuantity: parse(json['total_quantity']),
      totalAmount: parse(json['total_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'product_type': productType,
      'variation_name': variationName,
      'product_variation_name': productVariationName,
      'sku': sku,
      'total_quantity': totalQuantity,
      'total_amount': totalAmount,
    };
  }
}

class PaymentTypesModel {
  final String? advance;
  final String? cash;
  final String? other;

  PaymentTypesModel({this.advance, this.cash, this.other});

  factory PaymentTypesModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypesModel(
      advance: json['advance'],
      cash: json['cash'],
      other: json['other'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'advance': advance, 'cash': cash, 'other': other};
  }
}

class PosSettingsModel {
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

  PosSettingsModel({
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
    this.disablePayCheckout = 0,
    this.disableDraft = 0,
    this.disableExpressCheckout = 0,
    this.hideProductSuggestion = 0,
    this.hideRecentTrans = 0,
    this.disableDiscount = 0,
    this.disableOrderTax = 0,
  });

  factory PosSettingsModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return PosSettingsModel(
      amountRoundingMethod: json['amount_rounding_method'],
      enableMsp: json['enable_msp']?.toString(),
      cmmsnCalculationType: json['cmmsn_calculation_type'],

      razorPayKeyId: json['razor_pay_key_id'],
      razorPayKeySecret: json['razor_pay_key_secret'],
      stripePublicKey: json['stripe_public_key'],
      stripeSecretKey: json['stripe_secret_key'],

      isPosSubtotalEditable: json['is_pos_subtotal_editable']?.toString(),
      isServiceStaffRequired: json['is_service_staff_required']?.toString(),

      cashDenominations: json['cash_denominations'],
      enableCashDenominationOn: json['enable_cash_denomination_on'],

      disablePayCheckout: toInt(json['disable_pay_checkout']),
      disableDraft: toInt(json['disable_draft']),
      disableExpressCheckout: toInt(json['disable_express_checkout']),
      hideProductSuggestion: toInt(json['hide_product_suggestion']),
      hideRecentTrans: toInt(json['hide_recent_trans']),
      disableDiscount: toInt(json['disable_discount']),
      disableOrderTax: toInt(json['disable_order_tax']),
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
