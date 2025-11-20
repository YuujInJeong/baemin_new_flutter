import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/store.dart';
import '../repositories/store_repository.dart';
import '../repositories/mock_data.dart';

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository();
});

// 즉시 데이터를 반환하는 Provider (로딩 없음)
final storesProvider = Provider.family<List<Store>, Map<String, dynamic>>((ref, filters) {
  var stores = List<Store>.from(MockData.getStores()); // 복사본 생성

  // 필터링 (null이 아닐 때만 필터링)
  if (filters['isWow'] != null && filters['isWow'] == true) {
    stores = stores.where((s) => s.isWow == true).toList();
  }
  if (filters['isDiscount'] != null && filters['isDiscount'] == true) {
    stores = stores.where((s) => s.isDiscount == true).toList();
  }

  // 필터링 후 리스트가 비어있으면 원본 반환
  if (stores.isEmpty) {
    stores = List<Store>.from(MockData.getStores());
  }

  // 정렬
  final sortBy = filters['sortBy'] as String?;
  if (sortBy == 'rating') {
    stores.sort((a, b) => b.rating.compareTo(a.rating));
  } else if (sortBy == 'deliveryTime') {
    stores.sort((a, b) => a.deliveryTime.compareTo(b.deliveryTime));
  } else if (sortBy == 'minOrderPrice') {
    stores.sort((a, b) => a.minOrderPrice.compareTo(b.minOrderPrice));
  }

  return stores;
});

final storeDetailProvider = FutureProvider.family<Store, String>((ref, storeId) async {
  final repository = ref.watch(storeRepositoryProvider);
  return repository.getStoreById(storeId);
});

final favoriteStoresProvider = StateNotifierProvider<FavoriteStoresNotifier, List<String>>((ref) {
  return FavoriteStoresNotifier();
});

class FavoriteStoresNotifier extends StateNotifier<List<String>> {
  FavoriteStoresNotifier() : super([]);

  void toggleFavorite(String storeId) {
    if (state.contains(storeId)) {
      state = state.where((id) => id != storeId).toList();
    } else {
      state = [...state, storeId];
    }
  }

  bool isFavorite(String storeId) {
    return state.contains(storeId);
  }
}

