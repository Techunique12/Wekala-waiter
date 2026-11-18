class RegisterCheckModel {
  final bool success;
  final String? message;
  final RegisterCheckData? data;

  const RegisterCheckModel({required this.success, this.message, this.data});

  factory RegisterCheckModel.fromJson(Map<String, dynamic> json) {
    return RegisterCheckModel(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      data: json['data'] != null
          ? RegisterCheckData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class RegisterCheckData {
  final bool alreadyOpen;
  final int? id;
  final int? locationId;
  final int? businessId;
  final String? businessName;
  final String? locationName;
  final String? subType;
  final Map<String, String> businessLocations;

  const RegisterCheckData({
    required this.alreadyOpen,
    this.id,
    this.locationId,
    this.businessId,
    this.businessName,
    this.locationName,
    this.subType,
    this.businessLocations = const {},
  });

  factory RegisterCheckData.fromJson(Map<String, dynamic> json) {
    return RegisterCheckData(
      alreadyOpen: json['already_open'] ?? false,
      id: json['id'],
      locationId: json['location_id'],
      businessId: json['business_id'],
      businessName: json['business_name']?.toString(),
      locationName: json['location_name']?.toString(),
      subType: json['sub_type']?.toString(),
      businessLocations: json['business_locations'] != null
          ? Map<String, String>.from(
              json['business_locations'].map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            )
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'already_open': alreadyOpen,
      'id': id,
      'location_id': locationId,
      'business_id': businessId,
      'business_name': businessName,
      'location_name': locationName,
      'sub_type': subType,
      'business_locations': businessLocations,
    };
  }
}
