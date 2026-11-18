class RecentTransactionsResponse {
  final bool success;
  final String? message;
  final List<RecentTransactionModel> data;

  RecentTransactionsResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory RecentTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return RecentTransactionsResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => RecentTransactionModel.fromJson(e))
          .toList(),
    );
  }
}

class RecentTransactionModel {
  final int id;
  final int businessId;
  final int locationId;

  final String type;
  final String status;
  final String paymentStatus;

  final String invoiceNo;
  final int? queueNo;

  final DateTime transactionDate;

  final double totalBeforeTax;
  final double taxAmount;
  final double discountAmount;
  final double finalTotal;

  final int? taxId;

  final bool isSuspend;

  final int? typesOfServiceId;
  final double packingCharge;
  final String? packingChargeType;

  final String? additionalNotes;

  final ContactModel? contact;
  final TableModel? table;

  RecentTransactionModel({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.type,
    required this.status,
    required this.paymentStatus,
    required this.invoiceNo,
    this.queueNo,
    required this.transactionDate,
    required this.totalBeforeTax,
    required this.taxAmount,
    required this.discountAmount,
    required this.finalTotal,
    this.taxId,
    required this.isSuspend,
    this.typesOfServiceId,
    required this.packingCharge,
    this.packingChargeType,
    this.additionalNotes,
    this.contact,
    this.table,
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecentTransactionModel(
      id: json['id'] ?? 0,
      businessId: json['business_id'] ?? 0,
      locationId: json['location_id'] ?? 0,

      type: json['type'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',

      invoiceNo: json['invoice_no'] ?? '',
      queueNo: json['queue_no'],

      transactionDate: DateTime.parse(json['transaction_date'] ?? ''),

      totalBeforeTax: _toDouble(json['total_before_tax']),
      taxAmount: _toDouble(json['tax_amount']),
      discountAmount: _toDouble(json['discount_amount']),
      finalTotal: _toDouble(json['final_total']),

      taxId: json['tax_id'],

      isSuspend: json['is_suspend'] == 1,

      typesOfServiceId: json['types_of_service_id'],
      packingCharge: _toDouble(json['packing_charge']),
      packingChargeType: json['packing_charge_type'],

      additionalNotes: json['additional_notes'],

      contact: json['contact'] != null
          ? ContactModel.fromJson(json['contact'])
          : null,

      table: json['table'] != null ? TableModel.fromJson(json['table']) : null,
    );
  }

  static double _toDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}

class ContactModel {
  final int id;
  final String name;
  final String contactId;
  final String? mobile;
  final String type;

  ContactModel({
    required this.id,
    required this.name,
    required this.contactId,
    this.mobile,
    required this.type,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      contactId: json['contact_id'] ?? '',
      mobile: json['mobile'],
      type: json['type'] ?? '',
    );
  }
}

class TableModel {
  final int id;
  final String? name;

  TableModel({required this.id, this.name});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(id: json['id'] ?? 0, name: json['name']);
  }
}
