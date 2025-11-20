import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/menu_option.dart';

class CartRepository {
  final List<CartItem> _items = [];

  List<CartItem> getItems() => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> addItem({
    required MenuItem menuItem,
    required int quantity,
    required List<MenuOption> selectedOptions,
  }) async {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.menuId == menuItem.id &&
          _areOptionsEqual(item.selectedOptions, selectedOptions),
    );

    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          menuId: menuItem.id,
          menuName: menuItem.name,
          menuImageUrl: menuItem.imageUrl,
          basePrice: menuItem.price,
          quantity: quantity,
          selectedOptions: selectedOptions,
        ),
      );
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
  }

  Future<void> removeItem(String itemId) async {
    _items.removeWhere((item) => item.id == itemId);
  }

  Future<void> clear() async {
    _items.clear();
  }

  bool _areOptionsEqual(List<MenuOption> a, List<MenuOption> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toList()..sort();
    final bIds = b.map((e) => e.id).toList()..sort();
    return aIds.join(',') == bIds.join(',');
  }
}

