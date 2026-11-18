class UserModel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String username;
  final String email;
  final int? businessId;

  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    required this.username,
    required this.email,
    this.businessId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      email: json['email'],
      businessId: json['business_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'business_id': businessId,
    };
  }
}
