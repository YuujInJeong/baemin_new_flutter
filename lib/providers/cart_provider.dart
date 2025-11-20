import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/menu_option.dart';
import '../repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.watch(cartRepositoryProvider));
});

class CartState {
  final List<CartItem> items;
  final int itemCount;
  final int totalPrice;

  CartState({
    required this.items,
    required this.itemCount,
    required this.totalPrice,
  });

  CartState copyWith({
    List<CartItem>? items,
    int? itemCount,
    int? totalPrice,
  }) {
    return CartState(
      items: items ?? this.items,
      itemCount: itemCount ?? this.itemCount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repository;

  CartNotifier(this._repository) : super(CartState(items: [], itemCount: 0, totalPrice: 0)) {
    _loadCart();
  }

  void _loadCart() {
    final items = _repository.getItems();
    state = CartState(
      items: items,
      itemCount: _repository.itemCount,
      totalPrice: _repository.totalPrice,
    );
  }

  Future<void> addItem({
    required String storeId,
    required String storeName,
    required MenuItem menuItem,
    required int quantity,
    required List<MenuOption> selectedOptions,
  }) async {
    await _repository.addItem(
      storeId: storeId,
      storeName: storeName,
      menuItem: menuItem,
      quantity: quantity,
      selectedOptions: selectedOptions,
    );
    _loadCart();
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    await _repository.updateQuantity(itemId, quantity);
    _loadCart();
  }

  Future<void> removeItem(String itemId) async {
    await _repository.removeItem(itemId);
    _loadCart();
  }

  Future<void> clear() async {
    await _repository.clear();
    _loadCart();
  }
}

