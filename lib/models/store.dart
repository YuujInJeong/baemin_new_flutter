import 'menu_category.dart';

class Store {
  final String id;
  final String name;
  final double rating;
  final int reviewCount;
  final String thumbnailUrl;
  final double distance;
  final int deliveryTime;
  final int minOrderPrice;
  final bool isWow;
  final bool isDiscount;
  final bool hasFreeDelivery;
  final List<MenuCategory> menus;

  Store({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.thumbnailUrl,
    required this.distance,
    required this.deliveryTime,
    required this.minOrderPrice,
    required this.isWow,
    required this.isDiscount,
    required this.hasFreeDelivery,
    this.menus = const [],
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String,
      distance: (json['distance'] as num).toDouble(),
      deliveryTime: json['deliveryTime'] as int,
      minOrderPrice: json['minOrderPrice'] as int,
      isWow: json['isWow'] as bool? ?? false,
      isDiscount: json['isDiscount'] as bool? ?? false,
      hasFreeDelivery: json['hasFreeDelivery'] as bool? ?? false,
      menus: (json['menus'] as List<dynamic>?)
              ?.map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'reviewCount': reviewCount,
      'thumbnailUrl': thumbnailUrl,
      'distance': distance,
      'deliveryTime': deliveryTime,
      'minOrderPrice': minOrderPrice,
      'isWow': isWow,
      'isDiscount': isDiscount,
      'hasFreeDelivery': hasFreeDelivery,
      'menus': menus.map((e) => e.toJson()).toList(),
    };
  }
}

