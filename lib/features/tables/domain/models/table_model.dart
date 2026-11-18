class TableModel {
  final int id;
  final String name;
  final String location;
  final int? capacity;
  final int locationId;
  final String status;
  final int? transactionId;
  final String? customerName;
  final int? itemCount;
  final double? total;
  final String? description;
  final int? bookingId;
  final String? customerPhone;
  final int? guests;
  final String? bookingDate;
  final String? bookingTime;
  final bool? isArrived;
  final bool? pendingKitchen;

  TableModel({
    required this.id,
    required this.name,
    required this.location,
    this.capacity,
    required this.locationId,
    required this.status,
    this.transactionId,
    this.customerName,
    this.itemCount,
    this.total,
    this.description,
    this.bookingId,
    this.customerPhone,
    this.guests,
    this.bookingDate,
    this.bookingTime,
    this.isArrived,
    this.pendingKitchen,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      locationId: json['location_id'],
      status: json['status'],
      transactionId: json['transaction_id'],
      customerName: json['customer_name'],
      itemCount: json['item_count'],
      total: json['total'] != null
          ? double.tryParse(json['total'].toString())
          : null,
      description: json['description'],
      bookingId: json['booking_id'],
      customerPhone: json['customer_phone'],
      guests: json['guests'],
      bookingDate: json['booking_date'],
      bookingTime: json['booking_time'],
      isArrived: json['is_arrived'],
      pendingKitchen: json['items_pending_kitchen'] == null
          ? null
          : json['items_pending_kitchen'] == 1,
    );
  }

  TableModel copyWith({
    int? id,
    String? name,
    String? location,
    int? capacity,
    int? locationId,
    String? status,
    int? transactionId,
    String? customerName,
    int? itemCount,
    double? total,
    String? description,
    int? bookingId,
    String? customerPhone,
    int? guests,
    String? bookingDate,
    String? bookingTime,
    bool? isArrived,
    bool? pendingKitchen,
  }) {
    return TableModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      locationId: locationId ?? this.locationId,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      customerName: customerName ?? this.customerName,
      itemCount: itemCount ?? this.itemCount,
      total: total ?? this.total,
      description: description ?? this.description,
      bookingId: bookingId ?? this.bookingId,
      customerPhone: customerPhone ?? this.customerPhone,
      guests: guests ?? this.guests,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      isArrived: isArrived ?? this.isArrived,
      pendingKitchen: pendingKitchen ?? this.pendingKitchen,
    );
  }
}
