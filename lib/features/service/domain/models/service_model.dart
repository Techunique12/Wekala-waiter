class ServiceModel {
  final int id;
  final String name;
  final String? icon;
  final bool requiresTable;
  final String? description;
  final int businessId;
  final Map<String, String> locationPriceGroup;
  final double packingCharge;
  final String packingChargeType;
  final bool enableCustomFields;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceModel({
    required this.id,
    required this.name,
    this.icon,
    required this.requiresTable,
    this.description,
    required this.businessId,
    required this.locationPriceGroup,
    required this.packingCharge,
    required this.packingChargeType,
    required this.enableCustomFields,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'] ?? '',
      icon: json['icon'],
      requiresTable: json['requires_table'] == 1,
      description: json['description'],
      businessId: json['business_id'],
      locationPriceGroup: Map<String, String>.from(
        json['location_price_group'] ?? {},
      ),
      packingCharge:
          double.tryParse(json['packing_charge']?.toString() ?? '0') ?? 0,
      packingChargeType: json['packing_charge_type'] ?? 'fixed',
      enableCustomFields: json['enable_custom_fields'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}
