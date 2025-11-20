import 'menu_option.dart';

class CartItem {
  final String id;
  final String storeId;
  final String storeName;
  final String menuId;
  final String menuName;
  final String menuImageUrl;
  final int basePrice;
  final int quantity;
  final List<MenuOption> selectedOptions;

  CartItem({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.menuId,
    required this.menuName,
    required this.menuImageUrl,
    required this.basePrice,
    required this.quantity,
    this.selectedOptions = const [],
  });

  int get totalPrice {
    final optionsPrice = selectedOptions.fold<int>(
      0,
      (sum, option) => sum + option.price,
    );
    return (basePrice + optionsPrice) * quantity;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      menuId: json['menuId'] as String,
      menuName: json['menuName'] as String,
      menuImageUrl: json['menuImageUrl'] as String,
      basePrice: json['basePrice'] as int,
      quantity: json['quantity'] as int,
      selectedOptions: (json['selectedOptions'] as List<dynamic>?)
              ?.map((e) => MenuOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeId': storeId,
      'storeName': storeName,
      'menuId': menuId,
      'menuName': menuName,
      'menuImageUrl': menuImageUrl,
      'basePrice': basePrice,
      'quantity': quantity,
      'selectedOptions': selectedOptions.map((e) => e.toJson()).toList(),
    };
  }

  CartItem copyWith({
    String? id,
    String? storeId,
    String? storeName,
    String? menuId,
    String? menuName,
    String? menuImageUrl,
    int? basePrice,
    int? quantity,
    List<MenuOption>? selectedOptions,
  }) {
    return CartItem(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      menuId: menuId ?? this.menuId,
      menuName: menuName ?? this.menuName,
      menuImageUrl: menuImageUrl ?? this.menuImageUrl,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }
}

