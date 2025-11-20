import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/store_provider.dart';
import '../widgets/cart_fab.dart';
import '../repositories/mock_data.dart';

class StoreDetailScreen extends ConsumerStatefulWidget {
  final String storeId;

  const StoreDetailScreen({super.key, required this.storeId});

  @override
  ConsumerState<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends ConsumerState<StoreDetailScreen> {
  int _currentImageIndex = 0;
  int _selectedMenuTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final storeAsync = ref.watch(storeDetailProvider(widget.storeId));
    final favoriteIds = ref.watch(favoriteStoresProvider);
    final isFavorite = favoriteIds.contains(widget.storeId);

    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      body: storeAsync.when(
        data: (store) => CustomScrollView(
          slivers: [
            // 헤더 (이미지 Carousel)
            _buildImageCarousel(store, isFavorite),
            // 가게 정보
            SliverToBoxAdapter(
              child: _buildStoreInfo(store, isFavorite),
            ),
            // 리뷰 스니펫
            SliverToBoxAdapter(
              child: _buildReviewSnippet(),
            ),
            // 메뉴 탭
            SliverToBoxAdapter(
              child: _buildMenuTabs(store),
            ),
            // 메뉴 리스트
            _buildMenuList(store),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: const CartFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildImageCarousel(store, bool isFavorite) {
    final images = [
      store.thumbnailUrl,
      MockData.placeholderImage,
      MockData.placeholderImage,
    ];

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
            items: images.asMap().entries.map((entry) {
              final index = entry.key;
              final image = entry.value;
              return Builder(
                builder: (BuildContext context) {
                  return Semantics(
                    label: '가게 이미지 ${index + 1}',
                    hint: '${images.length}개 중 ${index + 1}번째 이미지입니다.',
                    image: true,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppTheme.bgGray,
                      ),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Semantics(
                            label: '가게 이미지 로드 실패',
                            image: true,
                            child: Container(
                              color: AppTheme.bgGray,
                              child: const Icon(Icons.image, size: 64, color: AppTheme.textGray),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          // Indicator
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Semantics(
              label: '이미지 인디케이터',
              hint: '현재 ${_currentImageIndex + 1}번째 이미지를 보고 있습니다. 총 ${images.length}개의 이미지가 있습니다.',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.asMap().entries.map((entry) {
                  final isSelected = _currentImageIndex == entry.key;
                  return Semantics(
                    label: '이미지 인디케이터 ${entry.key + 1}',
                    hint: isSelected ? '현재 선택된 이미지입니다.' : '누르시면 ${entry.key + 1}번째 이미지로 이동합니다.',
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentImageIndex = entry.key;
                        });
                      },
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // 우측 상단 버튼들
          Positioned(
            top: 40,
            right: 16,
            child: Row(
              children: [
                Semantics(
                  label: '이미지 확대 버튼',
                  hint: '누르시면 가게 이미지를 확대해서 볼 수 있습니다.',
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                Semantics(
                  label: '공유 버튼',
                  hint: '누르시면 가게 정보를 공유할 수 있습니다.',
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                Semantics(
                  label: isFavorite ? '즐겨찾기 해제 버튼' : '즐겨찾기 추가 버튼',
                  hint: isFavorite 
                      ? '누르시면 즐겨찾기에서 제거됩니다.'
                      : '누르시면 즐겨찾기에 추가됩니다.',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      ref.read(favoriteStoresProvider.notifier).toggleFavorite(widget.storeId);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfo(store, bool isFavorite) {
    final formatter = NumberFormat('#,###');
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 가게명
          Semantics(
            label: '가게명',
            child: Text(
              store.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textBlack,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 평점
          Semantics(
            label: '평점 ${store.rating}점, 리뷰 ${store.reviewCount}개',
            child: Row(
              children: [
                Semantics(
                  label: '별점 아이콘',
                  image: true,
                  child: const Icon(Icons.star, size: 18, color: AppTheme.yellow),
                ),
                const SizedBox(width: 4),
                Text(
                  '${store.rating}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textBlack,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${store.reviewCount})',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 태그들
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (store.isWow)
                Semantics(
                  label: 'WOW 배지',
                  hint: 'WOW 회원 혜택을 받을 수 있는 가게입니다.',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.wowBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'WOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (store.isDiscount)
                Semantics(
                  label: '즉시할인 배지',
                  hint: '즉시할인 혜택이 적용되는 가게입니다.',
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '즉시할인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // 배달 정보
          Semantics(
            label: '배달시간 ${store.deliveryTime}분, 포장시간 ${store.deliveryTime - 10}분',
            child: Row(
              children: [
                Semantics(
                  label: '시간 아이콘',
                  image: true,
                  child: const Icon(Icons.access_time, size: 16, color: AppTheme.textGray),
                ),
                const SizedBox(width: 4),
                Text(
                  '배달 ${store.deliveryTime}분 / 포장 ${store.deliveryTime - 10}분',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            label: '최소주문금액 ${formatter.format(store.minOrderPrice)}원',
            child: Text(
              '최소주문 ${formatter.format(store.minOrderPrice)}원',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textGray,
              ),
            ),
          ),
          if (store.hasFreeDelivery) ...[
            const SizedBox(height: 8),
            Semantics(
              label: '무료배송',
              hint: '이 가게는 무료배송이 가능합니다.',
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.bgGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Semantics(
                      label: '배송 아이콘',
                      image: true,
                      child: const Icon(Icons.local_shipping, size: 16, color: AppTheme.primaryBlue),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '무료배송',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewSnippet() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: '섹션 제목',
            child: const Text(
              '리뷰',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textBlack,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Semantics(
            label: '리뷰 미리보기',
            hint: '고객 리뷰의 일부를 미리 볼 수 있습니다.',
            child: Row(
              children: [
                Semantics(
                  label: '리뷰 이미지',
                  hint: '리뷰에 첨부된 음식 사진입니다.',
                  image: true,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.bgGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, color: AppTheme.textGray),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    label: '리뷰 내용',
                    child: const Text(
                      '맛있어요! 배달도 빨라요. 다음에도 주문할게요.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textBlack,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTabs(store) {
    if (store.menus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 50,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: store.menus.length,
        itemBuilder: (context, index) {
          final category = store.menus[index];
          final isSelected = _selectedMenuTabIndex == index;
          return Semantics(
            label: '${category.title} 메뉴 탭',
            hint: '${isSelected ? '현재 선택된' : '누르시면'} ${category.title} 메뉴를 볼 수 있습니다.',
            button: true,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMenuTabIndex = index;
                });
              },
              child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.textBlack,
                  ),
                ),
              ),
            ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildMenuList(store) {
    if (store.menus.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final selectedCategory = store.menus[_selectedMenuTabIndex];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final menuItem = selectedCategory.items[index];
          return _buildMenuItemCard(menuItem, store.id);
        },
        childCount: selectedCategory.items.length,
      ),
    );
  }

  Widget _buildMenuItemCard(menuItem, String storeId) {
    final formatter = NumberFormat('#,###');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지
          Semantics(
            label: '${menuItem.name} 메뉴 이미지',
            image: true,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.bgGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                menuItem.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Semantics(
                    label: '${menuItem.name} 메뉴 이미지 로드 실패',
                    image: true,
                    child: const Icon(Icons.image, color: AppTheme.textGray),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: '메뉴명',
                  child: Text(
                    menuItem.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Semantics(
                  label: '가격 ${formatter.format(menuItem.price)}원',
                  child: Text(
                    formatter.format(menuItem.price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Semantics(
                  label: '메뉴 설명',
                  child: Text(
                    menuItem.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (menuItem.reviewCount != null) ...[
                  const SizedBox(height: 4),
                  Semantics(
                    label: '리뷰 ${menuItem.reviewCount}개',
                    child: Text(
                      '리뷰 ${menuItem.reviewCount}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textGray,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 담기 버튼
          Semantics(
            label: '${menuItem.name} 장바구니 담기 버튼',
            hint: '누르시면 메뉴 옵션 선택 화면으로 이동합니다.',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryBlue),
              onPressed: () {
                context.push('/store/$storeId/menu/${menuItem.id}');
              },
            ),
          ),
        ],
      ),
    );
  }
}

