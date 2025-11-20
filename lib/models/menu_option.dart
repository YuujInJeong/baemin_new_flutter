class MenuOption {
  final String id;
  final String title;
  final int price;

  MenuOption({
    required this.id,
    required this.title,
    required this.price,
  });

  factory MenuOption.fromJson(Map<String, dynamic> json) {
    return MenuOption(
      id: json['id'] as String,
      title: json['title'] as String,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
    };
  }
}

