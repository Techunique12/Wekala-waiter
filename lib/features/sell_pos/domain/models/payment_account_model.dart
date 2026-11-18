class PaymentAccountModel {
  final String method;
  final bool isEnabled;
  final dynamic account;

  PaymentAccountModel({
    required this.method,
    required this.isEnabled,
    this.account,
  });

  factory PaymentAccountModel.fromJson(
    String method,
    Map<String, dynamic> json,
  ) {
    return PaymentAccountModel(
      method: method,
      isEnabled: json['is_enabled'] == '1' || json['is_enabled'] == 1,
      account: json['account'],
    );
  }
}
