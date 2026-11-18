class RegisterOpenModel {
  final bool success;
  final String? message;
  final RegisterOpenData? data;

  RegisterOpenModel({required this.success, this.message, this.data});

  factory RegisterOpenModel.fromJson(Map<String, dynamic> json) {
    return RegisterOpenModel(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? RegisterOpenData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class RegisterOpenData {
  final int businessId;
  final int userId;
  final String status;
  final int locationId;
  final String createdAt;
  final String updatedAt;
  final int id;

  RegisterOpenData({
    required this.businessId,
    required this.userId,
    required this.status,
    required this.locationId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory RegisterOpenData.fromJson(Map<String, dynamic> json) {
    return RegisterOpenData(
      businessId: json['business_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      status: json['status'] ?? '',
      locationId: json['location_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_id': businessId,
      'user_id': userId,
      'status': status,
      'location_id': locationId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'id': id,
    };
  }
}
