import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CartFAB extends ConsumerWidget {
  const CartFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final formatter = NumberFormat('#,###');

    if (cartState.itemCount == 0) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: '장바구니 버튼',
      hint: '현재 ${cartState.itemCount}개의 메뉴가 담겨있고 총 ${formatter.format(cartState.totalPrice)}원입니다. 누르시면 장바구니 화면으로 이동합니다.',
      button: true,
      child: GestureDetector(
        onTap: () => context.push('/cart'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Semantics(
                    label: '장바구니 아이콘',
                    image: true,
                    child: const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                  ),
                  if (cartState.itemCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Semantics(
                        label: '장바구니 아이템 개수 ${cartState.itemCount}개',
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cartState.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Semantics(
                label: '장바구니 총 금액 ${formatter.format(cartState.totalPrice)}원',
                child: Text(
                  '${formatter.format(cartState.totalPrice)}원',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
