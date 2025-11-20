enum AddressType { home, company, other }

class Address {
  final String id;
  final String address;
  final String detailAddress;
  final bool isDefault;
  final AddressType type;
  final String? directions; // 길 안내

  Address({
    required this.id,
    required this.address,
    required this.detailAddress,
    this.isDefault = false,
    this.type = AddressType.home,
    this.directions,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      address: json['address'] as String,
      detailAddress: json['detailAddress'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      type: AddressType.values.firstWhere(
        (e) => e.toString() == 'AddressType.${json['type']}',
        orElse: () => AddressType.home,
      ),
      directions: json['directions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'detailAddress': detailAddress,
      'isDefault': isDefault,
      'type': type.toString().split('.').last,
      'directions': directions,
    };
  }

  String get fullAddress => '$address $detailAddress';
  
  String get typeLabel {
    switch (type) {
      case AddressType.home:
        return '집';
      case AddressType.company:
        return '회사';
      case AddressType.other:
        return '기타';
    }
  }
}

