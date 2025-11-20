import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/store.dart';
import '../repositories/store_repository.dart';

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository();
});

final storesProvider = FutureProvider.family<List<Store>, Map<String, dynamic>>((ref, filters) async {
  final repository = ref.watch(storeRepositoryProvider);
  return repository.getStores(
    isWow: filters['isWow'] as bool?,
    isDiscount: filters['isDiscount'] as bool?,
    sortBy: filters['sortBy'] as String?,
  );
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

