import 'menu_option.dart';

class MenuItem {
  final String id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;
  final int? reviewCount;
  final List<MenuOption>? options;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.reviewCount,
    this.options,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      reviewCount: json['reviewCount'] as int?,
      options: json['options'] != null
          ? (json['options'] as List<dynamic>)
              .map((e) => MenuOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'reviewCount': reviewCount,
      'options': options?.map((e) => e.toJson()).toList(),
    };
  }
}

