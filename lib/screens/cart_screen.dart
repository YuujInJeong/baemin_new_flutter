import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String _deliveryOption = 'wow'; // 'wow' or 'normal'

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final address = ref.watch(addressProvider);
    final formatter = NumberFormat('#,###');

    final deliveryFee = _deliveryOption == 'wow' ? 0 : 1000;
    final discount = cartState.totalPrice > 0 ? 2000 : 0; // 더미 할인
    final finalTotal = cartState.totalPrice + deliveryFee - discount;

    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('장바구니'),
      ),
      body: cartState.items.isEmpty
          ? const Center(
            child: Text(
                '장바구니가 비어있습니다',
                style: TextStyle(color: AppTheme.textGray),
            ),
            )
          : Column(
        children: [
                Expanded(
                  child: SingleChildScrollView(
        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 주소
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                              Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                                    Semantics(
                                      label: '섹션 제목',
                                      child: const Text(
                                        '배송 주소',
            style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textGray,
            ),
          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Semantics(
                                      label: '현재 배송 주소',
                                      hint: address?.fullAddress ?? '주소를 선택하세요',
              child: Text(
                                        address?.fullAddress ?? '주소를 선택하세요',
                                        style: const TextStyle(
                                          fontSize: 16,
                  fontWeight: FontWeight.w600,
                                          color: AppTheme.textBlack,
              ),
            ),
          ),
        ],
      ),
                              ),
                              Semantics(
                                label: '주소 수정 버튼',
                                hint: '누르시면 주소 관리 화면으로 이동합니다.',
                                button: true,
                                child: TextButton(
                                  onPressed: () => context.push('/address'),
                                  child: const Text('수정'),
              ),
            ),
          ],
        ),
      ),
                        const SizedBox(height: 8),
                        // 배송 옵션
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                              Semantics(
                                label: '섹션 제목',
                                child: const Text(
                                  '배송 옵션',
            style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textBlack,
            ),
          ),
                              ),
                              const SizedBox(height: 12),
                              Semantics(
                                label: 'WOW 무료배달 옵션',
                                hint: _deliveryOption == 'wow' ? '현재 선택된 배송 옵션입니다. 무료로 배달됩니다.' : '선택하면 무료로 배달됩니다.',
                                child: RadioListTile<String>(
                                  value: 'wow',
                                  groupValue: _deliveryOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _deliveryOption = value!;
                                    });
                                  },
                                  title: const Text('WOW 무료배달'),
                                  subtitle: const Text('무료'),
                                  activeColor: AppTheme.primaryBlue,
      ),
                              ),
                              Semantics(
                                label: '한집 배달 옵션',
                                hint: _deliveryOption == 'normal' ? '현재 선택된 배송 옵션입니다. 추가로 ${formatter.format(1000)}원이 부과됩니다.' : '선택하면 추가로 ${formatter.format(1000)}원이 부과됩니다.',
                                child: RadioListTile<String>(
                                  value: 'normal',
                                  groupValue: _deliveryOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _deliveryOption = value!;
                                    });
                                  },
                                  title: const Text('한집 배달'),
                                  subtitle: Text('+${formatter.format(1000)}원'),
                                  activeColor: AppTheme.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 장바구니 리스트
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                              Semantics(
                                label: '섹션 제목',
                                child: const Text(
                                  '주문 내역',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                                    color: AppTheme.textBlack,
                      ),
                    ),
                              ),
                              const SizedBox(height: 12),
                              ...cartState.items.map((item) {
                                return _buildCartItem(item, formatter);
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100), // 하단 버튼 공간
                      ],
                    ),
                  ),
                ),
                // 하단 결제 바
                      Container(
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
                  child: Column(
                    children: [
                      Semantics(
                        label: '주문 금액 ${formatter.format(cartState.totalPrice)}원',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '주문 금액',
                  style: TextStyle(
                    fontSize: 14,
                                color: AppTheme.textGray,
                  ),
                ),
                  Text(
                              '${formatter.format(cartState.totalPrice)}원',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textBlack,
                    ),
                  ),
                ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: deliveryFee > 0 ? '배달비 ${formatter.format(deliveryFee)}원' : '배달비 무료',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '배달비',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textGray,
            ),
          ),
          Text(
                              deliveryFee > 0
                                  ? '+${formatter.format(deliveryFee)}원'
                                  : '무료',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textBlack,
            ),
          ),
        ],
      ),
                      ),
                      if (discount > 0) ...[
                        const SizedBox(height: 8),
                        Semantics(
                          label: '즉시할인 ${formatter.format(discount)}원',
                          hint: '할인 혜택이 적용되었습니다.',
                          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                              const Text(
                                '즉시할인',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
              Text(
                                '-${formatter.format(discount)}원',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
            ],
          ),
                        ),
                      ],
                      const Divider(),
                      Semantics(
                        label: '최종 결제 금액 ${formatter.format(finalTotal)}원',
                        hint: cartState.totalPrice != finalTotal 
                            ? '원래 가격 ${formatter.format(cartState.totalPrice + deliveryFee)}원에서 할인이 적용되었습니다.'
                            : '',
                        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                            if (cartState.totalPrice != finalTotal)
                              Semantics(
                                label: '원래 가격',
                                hint: '할인 전 가격입니다.',
                                child: Text(
                                  '${formatter.format(cartState.totalPrice + deliveryFee)}원',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textGray,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                ),
              ),
              Text(
                              '${formatter.format(finalTotal)}원',
                              style: const TextStyle(
                                fontSize: 20,
                  fontWeight: FontWeight.bold,
                                color: AppTheme.textBlack,
                ),
              ),
            ],
          ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: '결제하기 버튼',
                        hint: '총 ${formatter.format(finalTotal)}원입니다. 누르시면 결제 화면으로 이동합니다.',
                        button: true,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.push('/checkout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              '결제하기',
                  style: TextStyle(
                                fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                            ),
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

  Widget _buildCartItem(item, formatter) {
    return Semantics(
      label: '${item.menuName} 장바구니 아이템',
      hint: '수량 ${item.quantity}개, 총 ${formatter.format(item.totalPrice)}원입니다.',
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지
            Semantics(
              label: '${item.menuName} 메뉴 이미지',
              hint: '${item.menuName}의 음식 사진입니다.',
              image: true,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.bgGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  item.menuImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Semantics(
                      label: '${item.menuName} 메뉴 이미지 로드 실패',
                      hint: '이미지를 불러올 수 없습니다.',
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
                    item.menuName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textBlack,
                    ),
                  ),
                ),
                if (item.selectedOptions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Semantics(
                    label: '선택된 옵션',
                    child: Text(
                      item.selectedOptions.map((opt) => opt.title).join(', '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textGray,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      label: '총 가격 ${formatter.format(item.totalPrice)}원',
                      child: Text(
                        '${formatter.format(item.totalPrice)}원',
                        style: const TextStyle(
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
                          hint: item.quantity > 1 ? '누르시면 수량이 1개 감소합니다.' : '수량이 1개이므로 더 이상 감소할 수 없습니다.',
                          button: true,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            onPressed: item.quantity > 1
                                ? () {
                                    ref.read(cartProvider.notifier).updateQuantity(
                                          item.id,
                                          item.quantity - 1,
                                        );
                                  }
                                : null,
                          ),
                        ),
                        Semantics(
                          label: '현재 수량 ${item.quantity}개',
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Semantics(
                          label: '수량 증가 버튼',
                          hint: '누르시면 수량이 1개 증가합니다.',
                          button: true,
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            onPressed: () {
                              ref.read(cartProvider.notifier).updateQuantity(
                                    item.id,
                                    item.quantity + 1,
                                  );
                            },
                          ),
                        ),
                        Semantics(
                          label: '삭제 버튼',
                          hint: '누르시면 ${item.menuName}이 장바구니에서 삭제됩니다.',
                          button: true,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              ref.read(cartProvider.notifier).removeItem(item.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
                ),
              );
  }
}
