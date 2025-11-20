import '../models/store.dart';
import 'mock_data.dart';

class StoreRepository {
  Future<List<Store>> getStores({
    bool? isWow,
    bool? isDiscount,
    String? sortBy,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var stores = MockData.getStores();

    // 필터링
    if (isWow != null) {
      stores = stores.where((s) => s.isWow == isWow).toList();
    }
    if (isDiscount != null) {
      stores = stores.where((s) => s.isDiscount == isDiscount).toList();
    }

    // 정렬
    if (sortBy == 'rating') {
      stores.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sortBy == 'deliveryTime') {
      stores.sort((a, b) => a.deliveryTime.compareTo(b.deliveryTime));
    } else if (sortBy == 'minOrderPrice') {
      stores.sort((a, b) => a.minOrderPrice.compareTo(b.minOrderPrice));
    }

    return stores;
  }

  Future<Store> getStoreById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.getStoreDetail(id);
  }

  Future<List<Store>> searchStores(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final stores = MockData.getStores();
    return stores
        .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

