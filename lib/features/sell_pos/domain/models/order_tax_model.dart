class TaxRateModel {
  final int? id;
  final String name;
  final double amount;

  const TaxRateModel({
    required this.id,
    required this.name,
    required this.amount,
  });

  factory TaxRateModel.fromJson({
    required String id,
    required String name,
    double amount = 0.0,
  }) {
    return TaxRateModel(
      id: id.isEmpty ? null : int.tryParse(id),
      name: name,
      amount: amount,
    );
  }

  bool get isNoTax => id == null;

  @override
  String toString() {
    return 'TaxRateModel('
        'id: $id, '
        'name: $name, '
        'amount: $amount'
        ')';
  }
}
