import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/store_provider.dart';
import '../providers/cart_provider.dart';
import '../models/menu_item.dart';

class MenuOptionScreen extends ConsumerStatefulWidget {
  final String storeId;
  final String menuId;

  const MenuOptionScreen({
    super.key,
    required this.storeId,
    required this.menuId,
  });

  @override
  ConsumerState<MenuOptionScreen> createState() => _MenuOptionScreenState();
}

class _MenuOptionScreenState extends ConsumerState<MenuOptionScreen> {
  int _quantity = 1;
  final List<String> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    final storeAsync = ref.watch(storeDetailProvider(widget.storeId));

    return storeAsync.when(
      data: (store) {
        MenuItem? menuItem;
        for (final category in store.menus) {
          final item = category.items.firstWhere(
            (item) => item.id == widget.menuId,
            orElse: () => category.items.first,
          );
          if (item.id == widget.menuId) {
            menuItem = item;
            break;
      }
        }

        if (menuItem == null) {
          return const Scaffold(
            body: Center(child: Text('메뉴를 찾을 수 없습니다')),
          );
        }

        // menuItem이 null이 아님을 보장
        final selectedMenuItem = menuItem;

        final formatter = NumberFormat('#,###');
        final basePrice = selectedMenuItem.price;
        final optionsPrice = _selectedOptions.fold<int>(
          0,
          (sum, optionId) {
            final option = selectedMenuItem.options?.firstWhere(
              (opt) => opt.id == optionId,
              orElse: () => selectedMenuItem.options!.first,
            );
            return sum + (option?.price ?? 0);
          },
        );
        final totalPrice = (basePrice + optionsPrice) * _quantity;

    return Scaffold(
          backgroundColor: Colors.white,
      appBar: AppBar(
            title: const Text('메뉴 옵션'),
      ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지
                Semantics(
                  label: '${selectedMenuItem.name} 메뉴 이미지',
                  hint: '${selectedMenuItem.name}의 음식 사진입니다.',
                  image: true,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    color: AppTheme.bgGray,
                    child: Image.network(
                      selectedMenuItem.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Semantics(
                          label: '${selectedMenuItem.name} 메뉴 이미지 로드 실패',
                          hint: '이미지를 불러올 수 없습니다.',
                          image: true,
                          child: const Icon(Icons.image, size: 64, color: AppTheme.textGray),
                        );
                      },
                    ),
                  ),
                ),
                // 제목과 가격
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        label: '메뉴명',
                        child: Text(
                          selectedMenuItem.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: '기본 가격 ${formatter.format(basePrice)}원',
                        child: Text(
                          '${formatter.format(basePrice)}원',
                          style: const TextStyle(
                        fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textBlack,
                          ),
                        ),
                      ),
                      if (selectedMenuItem.description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          selectedMenuItem.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textGray,
                          ),
                        ),
                      ],
              ],
            ),
          ),
                const Divider(),
                // 수량 조절
          Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Semantics(
                        label: '수량 선택',
                        child: const Text(
                          '수량',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textBlack,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Semantics(
                            label: '수량 감소 버튼',
                            hint: _quantity > 1 ? '누르시면 수량이 1개 감소합니다.' : '수량이 1개이므로 더 이상 감소할 수 없습니다.',
                            button: true,
                            child: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: _quantity > 1
                                  ? () {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  : null,
                            ),
                          ),
                          Semantics(
                            label: '현재 수량 $_quantity개',
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Semantics(
                            label: '수량 증가 버튼',
                            hint: '누르시면 수량이 1개 증가합니다.',
                            button: true,
                            child: IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ),
                        ],
          ),
        ],
      ),
                ),
                // 사이드 메뉴 옵션
                if (selectedMenuItem.options != null && selectedMenuItem.options!.isNotEmpty) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                        Semantics(
                          label: '섹션 제목',
                          child: const Text(
                            '사이드 메뉴',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                              color: AppTheme.textBlack,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...selectedMenuItem.options!.map((option) {
                          final isSelected = _selectedOptions.contains(option.id);
                          return Semantics(
                            label: '${option.title} 사이드 메뉴 옵션',
                            hint: option.price > 0 
                                ? '추가 가격 ${formatter.format(option.price)}원입니다. ${isSelected ? "현재 선택되어 있습니다." : "체크하면 추가됩니다."}'
                                : '무료로 추가할 수 있습니다. ${isSelected ? "현재 선택되어 있습니다." : "체크하면 추가됩니다."}',
                            child: CheckboxListTile(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedOptions.add(option.id);
                                  } else {
                                    _selectedOptions.remove(option.id);
                                  }
                                });
                              },
                              title: Text(option.title),
                              subtitle: Text(
                                option.price > 0
                                    ? '+${formatter.format(option.price)}원'
                                    : '무료',
                                style: const TextStyle(color: AppTheme.textGray),
                              ),
                              activeColor: AppTheme.primaryBlue,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 100), // 하단 버튼 공간
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (basePrice * _quantity != totalPrice)
                      Text(
                        '${formatter.format(basePrice * _quantity)}원',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textGray,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      '${formatter.format(totalPrice)}원',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textBlack,
                      ),
                    ),
                  ],
                ),
                Semantics(
                  label: '장바구니 담기 버튼',
                  hint: '현재 수량 $_quantity개, 총 ${formatter.format(totalPrice)}원입니다. 누르시면 장바구니에 추가되고 이전 화면으로 돌아갑니다.',
                  button: true,
                  child: ElevatedButton(
                    onPressed: () async {
                      final selectedOptionsList = selectedMenuItem.options
                              ?.where((opt) => _selectedOptions.contains(opt.id))
                              .toList() ??
                          [];
                      await ref.read(cartProvider.notifier).addItem(
                            storeId: widget.storeId,
                            storeName: store.name,
                            menuItem: selectedMenuItem,
                            quantity: _quantity,
                            selectedOptions: selectedOptionsList,
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('장바구니에 추가되었습니다')),
                        );
                        context.pop();
                      }
          },
          style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      '장바구니 담기',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
        ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
