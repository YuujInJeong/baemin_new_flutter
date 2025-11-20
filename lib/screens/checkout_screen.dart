import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/address_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _paymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final address = ref.watch(addressProvider);
    final formatter = NumberFormat('#,###');

    final deliveryFee = 0; // WOW 무료배달 가정
    final discount = 2000;
    final finalTotal = cartState.totalPrice + deliveryFee - discount;

    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('결제'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 주소 확인
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: '섹션 제목',
                    child: const Text(
                      '배송 주소',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    label: '배송 주소',
                    hint: address?.fullAddress ?? '주소를 선택하세요',
                    child: Text(
                      address?.fullAddress ?? '주소를 선택하세요',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 배송 시간
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    label: '섹션 제목',
                    child: const Text(
                      '배송 예상 시간',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textBlack,
                      ),
                    ),
                  ),
                  Semantics(
                    label: '배송 예상 시간 약 30분',
                    child: Text(
                      '약 30분',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 결제 수단
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: '섹션 제목',
                    child: const Text(
                      '결제 수단',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textBlack,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    label: '카드 결제 옵션',
                    hint: _paymentMethod == 'card' ? '현재 선택된 결제 수단입니다.' : '선택하면 카드로 결제합니다.',
                    child: RadioListTile<String>(
                      value: 'card',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                      title: const Text('카드 결제'),
                      activeColor: AppTheme.primaryBlue,
                    ),
                  ),
                  Semantics(
                    label: '계좌이체 옵션',
                    hint: _paymentMethod == 'account' ? '현재 선택된 결제 수단입니다.' : '선택하면 계좌이체로 결제합니다.',
                    child: RadioListTile<String>(
                      value: 'account',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                      title: const Text('계좌이체'),
                      activeColor: AppTheme.primaryBlue,
                    ),
                  ),
                  Semantics(
                    label: '현금 결제 옵션',
                    hint: _paymentMethod == 'cash' ? '현재 선택된 결제 수단입니다.' : '선택하면 현금으로 결제합니다.',
                    child: RadioListTile<String>(
                      value: 'cash',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                      title: const Text('현금 결제'),
                      activeColor: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            // 결제 금액 요약
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
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
                    label: '배달비 무료',
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
                        const Text(
                          '무료',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  const Divider(),
                  Semantics(
                    label: '최종 결제 금액 ${formatter.format(finalTotal)}원',
                    hint: '이 금액으로 결제가 진행됩니다.',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '최종 결제 금액',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textBlack,
                          ),
                        ),
                        Text(
                          '${formatter.format(finalTotal)}원',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
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
        child: Semantics(
          label: '결제하기 버튼',
          hint: '총 ${formatter.format(finalTotal)}원입니다. 누르시면 결제가 완료되고 홈 화면으로 이동합니다.',
          button: true,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // 더미 결제 처리
                ref.read(cartProvider.notifier).clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('결제가 완료되었습니다')),
                );
                context.go('/');
              },
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
      ),
    );
  }
}

