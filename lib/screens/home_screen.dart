import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/store_card.dart';
import '../widgets/section_header.dart';
import '../widgets/category_item.dart';
import '../widgets/cart_fab.dart';
import '../providers/store_provider.dart';
import '../providers/address_provider.dart';
import '../repositories/mock_data.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isWow = false;
  bool _isDiscount = false;
  String _sortBy = 'recommended';

  @override
  Widget build(BuildContext context) {
    final filters = {
      'isWow': _isWow ? true : null,
      'isDiscount': _isDiscount ? true : null,
      'sortBy': _sortBy,
    };

    final storesAsync = ref.watch(storesProvider(filters));

    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더 - 높이 56dp, 좌우 16dp padding
            _buildTopBar(context),
            // 본문
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 검색바
                    _buildSearchBar(context),
                    const SizedBox(height: 16),
                    // 카테고리 그리드 (2줄)
                    _buildCategoryGrid(),
                    const SizedBox(height: 16),
                    // WOW 배너
                    _buildWowBanner(),
                    const SizedBox(height: 16),
                    // 무료배달 섹션
                    storesAsync.when(
                      data: (stores) => _buildFreeDeliverySection(stores),
                      loading: () => Semantics(
                        label: '무료배달 가게 목록 로딩 중',
                        child: const SizedBox.shrink(),
                      ),
                      error: (error, stack) => Semantics(
                        label: '무료배달 가게 목록 로드 실패',
                        child: const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 기타 섹션들
                    storesAsync.when(
                      data: (stores) => _buildSections(stores),
                      loading: () => Semantics(
                        label: '가게 목록 로딩 중',
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Semantics(
                        label: '가게 목록 로드 실패: $error',
                        child: Center(child: Text('Error: $error')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const CartFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final address = ref.watch(addressProvider);
    return Container(
      height: 56, // 높이 56dp
      padding: const EdgeInsets.symmetric(horizontal: 16), // 좌우 16dp padding
      color: Colors.white,
      child: Row(
        children: [
          // 주소
          Expanded(
            child: Semantics(
              label: '주소 선택 버튼',
              hint: '현재 주소는 ${address?.address ?? "주소를 선택하세요"}입니다. 누르시면 주소 관리 화면으로 이동합니다.',
              button: true,
              child: GestureDetector(
                onTap: () => context.push('/address'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      label: '위치 아이콘',
                      image: true,
                      child: const Icon(Icons.location_on, size: 18, color: AppTheme.primaryBlue),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Semantics(
                        label: '현재 주소',
                        child: Text(
                          address?.address ?? '주소를 선택하세요',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textBlack,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Semantics(
                      label: '드롭다운 아이콘',
                      image: true,
                      child: const Icon(Icons.arrow_drop_down, size: 20, color: AppTheme.textGray),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 알림 아이콘
          Semantics(
            label: '알림 버튼',
            hint: '누르시면 알림 목록 화면으로 이동합니다.',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppTheme.textBlack),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Semantics(
        label: '메뉴 검색 입력창',
        hint: '오늘은 무엇을 드실건가요? 두번탭하면 검색 화면으로 이동합니다.',
        textField: true,
        child: GestureDetector(
          onTap: () => context.push('/search'),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderGray),
            ),
            child: Row(
              children: [
                Semantics(
                  label: '검색 아이콘',
                  image: true,
                  child: const Icon(Icons.search, color: AppTheme.textGray, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    label: '검색어 입력',
                    hint: '메뉴나 가게 이름을 입력하세요',
                    child: Text(
                      '오늘은 무엇을 드실건가요?',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.white,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemCount: MockData.categories.length + 1, // +1 for "더보기"
        itemBuilder: (context, index) {
          if (index == MockData.categories.length) {
            // 더보기 버튼
            return Semantics(
              label: '더보기 버튼',
              hint: '누르시면 전체 카테고리 목록 화면으로 이동합니다.',
              button: true,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Semantics(
                      label: '더보기 아이콘',
                      image: true,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.bgGray,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward, color: AppTheme.textGray),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Semantics(
                      label: '더보기 텍스트',
                      child: const Text(
                        '더보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textBlack,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          final category = MockData.categories[index];
          return CategoryItem(
            name: category['name']!,
            icon: category['icon']!,
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildWowBanner() {
    return Semantics(
      label: 'WOW 멤버십 배너',
      hint: '와우회원은 횟수 제한없이 매 주문 무료배달 혜택을 받을 수 있습니다.',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.wowBlue, AppTheme.primaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Semantics(
              label: 'WOW 배지',
              hint: 'WOW 회원 전용 혜택입니다.',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
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
            const SizedBox(width: 12),
            Expanded(
              child: Semantics(
                label: 'WOW 멤버십 혜택 안내',
                hint: '와우회원은 횟수 제한없이 매 주문 무료배달 혜택을 받을 수 있습니다.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '와우회원은 횟수 제한없이 매 주문 무료배달',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Semantics(
              label: '주문하러 가기 버튼',
              hint: '누르시면 주문 가능한 가게 목록 화면으로 이동합니다.',
              button: true,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '주문하러 가기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreeDeliverySection(List stores) {
    final freeDeliveryStores = stores.where((s) => s.hasFreeDelivery).take(3).toList();
    
    return Semantics(
      label: '무료배달 섹션',
      hint: '최소주문금액 걱정 없이 하나만 담아도 무료배달이 가능한 가게 목록입니다.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Semantics(
                  label: '무료배달 아이콘',
                  image: true,
                  child: const Icon(Icons.local_shipping, color: AppTheme.yellow, size: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    label: '무료배달 안내',
                    hint: '최소주문금액 걱정 없이 하나만 담아도 무료배달이 가능합니다.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '최소주문금액 걱정 없이 하나만 담아도 무료배달',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textBlack,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Semantics(
                  label: '전체보기 버튼',
                  hint: '누르시면 무료배달 가게 전체 목록 화면으로 이동합니다.',
                  button: true,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      '전체보기 >',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Semantics(
            label: '무료배달 가게 목록',
            hint: '${freeDeliveryStores.length}개의 무료배달 가게가 있습니다.',
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: freeDeliveryStores.length,
                itemBuilder: (context, index) {
                  final store = freeDeliveryStores[index];
                  return StoreCard(
                    store: store,
                    onTap: () => context.push('/store/${store.id}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSections(List stores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이츠 추천 맛집
        _buildStoreSection('이츠 추천 맛집', stores),
        const SizedBox(height: 24),
        // 우리 동네 인기 메뉴
        _buildStoreSection('우리 동네 인기 메뉴', stores),
        const SizedBox(height: 24),
        // 골라먹는 맛집
        _buildStoreSection('골라먹는 맛집', stores),
        const SizedBox(height: 24),
        // 광고 배너
        Semantics(
          label: '광고 배너',
          hint: '프로모션 광고입니다. 누르시면 광고 상세 페이지로 이동합니다.',
          button: true,
          image: true,
          child: GestureDetector(
            onTap: () {
              // 광고 상세 페이지로 이동
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.bgGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '광고 배너',
                  style: TextStyle(color: AppTheme.textGray),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // 패밀리레스토랑
        _buildStoreSection('패밀리레스토랑', stores),
        const SizedBox(height: 24),
        // 점심 인기 메뉴
        _buildStoreSection('점심 인기 메뉴', stores),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStoreSection(String title, List stores) {
    return Semantics(
      label: '$title 섹션',
      hint: '$title 가게 목록입니다.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          Semantics(
            label: '$title 가게 목록',
            hint: '${stores.length}개의 가게가 있습니다.',
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return StoreCard(
                    store: store,
                    onTap: () => context.push('/store/${store.id}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
