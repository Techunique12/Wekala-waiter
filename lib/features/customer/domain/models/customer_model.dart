class Customer {
  final int id;
  final String? text;
  final String mobile;

  final String? name;
  final String? contactId;

  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;

  final String? shippingAddress;
  final int? payTermNumber;
  final String? payTermType;

  final String balance;

  final String? supplierBusinessName;
  final double? discountPercent;
  final String? priceCalculationType;
  final int? sellingPriceGroupId;

  final String? shippingCustomFieldDetails;
  final int isExport;

  final String? exportCustomField1;
  final String? exportCustomField2;
  final String? exportCustomField3;
  final String? exportCustomField4;
  final String? exportCustomField5;
  final String? exportCustomField6;

  const Customer({
    required this.id,
    this.text,
    required this.mobile,
    this.name,
    this.contactId,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.shippingAddress,
    this.payTermNumber,
    this.payTermType,
    required this.balance,
    this.supplierBusinessName,
    this.discountPercent,
    this.priceCalculationType,
    this.sellingPriceGroupId,
    this.shippingCustomFieldDetails,
    required this.isExport,
    this.exportCustomField1,
    this.exportCustomField2,
    this.exportCustomField3,
    this.exportCustomField4,
    this.exportCustomField5,
    this.exportCustomField6,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      text: json['text'] as String?,
      mobile: json['mobile'] as String,

      name: json['name'] as String?,
      contactId: json['contact_id'] as String?,

      addressLine1: json['address_line_1'] as String?,
      addressLine2: json['address_line_2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      zipCode: json['zip_code'] as String?,

      shippingAddress: json['shipping_address'] as String?,

      payTermNumber: json['pay_term_number'] as int?,
      payTermType: json['pay_term_type'] as String?,

      balance: json['balance'] as String,

      supplierBusinessName: json['supplier_business_name'] as String?,

      discountPercent: (json['discount_percent'] as num?)?.toDouble(),

      priceCalculationType: json['price_calculation_type'] as String?,

      sellingPriceGroupId: json['selling_price_group_id'] as int?,

      shippingCustomFieldDetails:
          json['shipping_custom_field_details'] as String?,

      isExport: json['is_export'] as int,

      exportCustomField1: json['export_custom_field_1'] as String?,
      exportCustomField2: json['export_custom_field_2'] as String?,
      exportCustomField3: json['export_custom_field_3'] as String?,
      exportCustomField4: json['export_custom_field_4'] as String?,
      exportCustomField5: json['export_custom_field_5'] as String?,
      exportCustomField6: json['export_custom_field_6'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'mobile': mobile,

      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'zip_code': zipCode,

      'shipping_address': shippingAddress,
      'pay_term_number': payTermNumber,
      'pay_term_type': payTermType,

      'balance': balance,

      'supplier_business_name': supplierBusinessName,
      'discount_percent': discountPercent,
      'price_calculation_type': priceCalculationType,
      'selling_price_group_id': sellingPriceGroupId,

      'shipping_custom_field_details': shippingCustomFieldDetails,

      'is_export': isExport,

      'export_custom_field_1': exportCustomField1,
      'export_custom_field_2': exportCustomField2,
      'export_custom_field_3': exportCustomField3,
      'export_custom_field_4': exportCustomField4,
      'export_custom_field_5': exportCustomField5,
      'export_custom_field_6': exportCustomField6,
    };
  }
}
