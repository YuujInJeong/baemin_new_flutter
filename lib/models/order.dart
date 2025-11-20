class Order {
  final String id;
  final String storeId;
  final String storeName;
  final int totalPrice;
  final DateTime orderDate;
  final String status;

  Order({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      totalPrice: json['totalPrice'] as int,
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'storeName': storeName,
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }
}

