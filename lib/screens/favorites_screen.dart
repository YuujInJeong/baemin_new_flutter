import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/store_card.dart';
import '../providers/store_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoriteStoresProvider);
    final filters = <String, dynamic>{};
    final storesAsync = ref.watch(storesProvider(filters));

    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('즐겨찾기'),
      ),
      body: storesAsync.when(
        data: (allStores) {
          final favoriteStores = allStores.where((s) => favoriteIds.contains(s.id)).toList();

          if (favoriteStores.isEmpty) {
            return Semantics(
              label: '빈 상태',
              hint: '즐겨찾는 맛집이 없습니다. 가게 상세 화면에서 하트 아이콘을 눌러 즐겨찾기에 추가할 수 있습니다.',
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      label: '빈 상태 아이콘',
                      image: true,
                      child: Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: AppTheme.textGray,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '즐겨찾는 맛집이 없습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textGray,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteStores.length,
            itemBuilder: (context, index) {
              final store = favoriteStores[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: StoreCard(
                  store: store,
                  onTap: () => context.push('/store/${store.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
