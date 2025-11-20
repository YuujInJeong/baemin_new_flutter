import '../models/store.dart';
import 'mock_data.dart';

class StoreRepository {
  Future<List<Store>> getStores({
    bool? isWow,
    bool? isDiscount,
    String? sortBy,
  }) async {
    // 즉시 데이터 반환 (로딩 딜레이 제거)
    // await Future.delayed(const Duration(milliseconds: 100));

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
    // 즉시 데이터 반환
    // await Future.delayed(const Duration(milliseconds: 100));
    return MockData.getStoreDetail(id);
  }

  Future<List<Store>> searchStores(String query) async {
    // 즉시 데이터 반환
    // await Future.delayed(const Duration(milliseconds: 100));
    final stores = MockData.getStores();
    return stores
        .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

