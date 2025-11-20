import '../models/order.dart';
import '../models/cart_item.dart';

class OrderRepository {
  static final List<Order> _orders = [];

  Future<Order> createOrder({
    required String storeId,
    required String storeName,
    required List<CartItem> items,
    required int totalPrice,
  }) async {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      storeId: storeId,
      storeName: storeName,
      totalPrice: totalPrice,
      orderDate: DateTime.now(),
      status: '주문접수',
    );

    _orders.insert(0, order); // 최신 주문이 위로
    return order;
  }

  List<Order> getOrders() {
    return List.from(_orders);
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }
}

