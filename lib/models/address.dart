class Address {
  final String id;
  final String address;
  final String detailAddress;
  final bool isDefault;

  Address({
    required this.id,
    required this.address,
    required this.detailAddress,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'detailAddress': detailAddress,
      'isDefault': isDefault,
    };
  }

  String get fullAddress => '$address $detailAddress';
}

