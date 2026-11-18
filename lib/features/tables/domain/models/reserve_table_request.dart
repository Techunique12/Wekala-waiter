class ReserveTableRequest {
  final String customerName;
  final String? phone;
  final int guests;
  final String date;
  final String time;
  final int durationMinutes;
  final String? notes;

  const ReserveTableRequest({
    required this.customerName,
    this.phone,
    required this.guests,
    required this.date,
    required this.time,
    required this.durationMinutes,
    this.notes,
  });

  factory ReserveTableRequest.fromJson(Map<String, dynamic> json) {
    return ReserveTableRequest(
      customerName: json['customer_name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      guests: int.tryParse(json['guests']?.toString() ?? '') ?? 0,
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      durationMinutes:
          int.tryParse(json['duration_minutes']?.toString() ?? '') ?? 0,
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'phone': phone,
      'guests': guests,
      'date': date,
      'time': time,
      'duration_minutes': durationMinutes,
      'notes': notes,
    };
  }
}
