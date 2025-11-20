import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../repositories/mock_data.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = MockData.getOrders();
    final formatter = NumberFormat('#,###');
    final dateFormatter = DateFormat('yyyy.MM.dd');

    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('주문내역'),
      ),
      body: orders.isEmpty
          ? Semantics(
              label: '빈 상태 메시지',
              hint: '아직 주문한 내역이 없습니다.',
              child: const Center(
                child: Text(
                  '주문 내역이 없습니다',
                  style: TextStyle(color: AppTheme.textGray),
      ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
                            Semantics(
                              label: '주문 날짜',
                              child: Text(
                                dateFormatter.format(order.orderDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ),
                            Semantics(
                              label: '주문 상태 ${order.status}',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.bgGray,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  order.status,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textBlack,
          ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
          Semantics(
                            label: '가게명',
                            child: Text(
                              order.storeName,
                              style: const TextStyle(
                                fontSize: 16,
              fontWeight: FontWeight.w600,
                                color: AppTheme.textBlack,
            ),
          ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
          Semantics(
                              label: '주문 금액 ${formatter.format(order.totalPrice)}원',
                              child: Text(
                                '${formatter.format(order.totalPrice)}원',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textBlack,
            ),
            ),
          ),
                            Semantics(
                              label: '재주문 버튼',
                              hint: '${order.storeName}에서 ${formatter.format(order.totalPrice)}원 주문을 다시 주문할 수 있습니다.',
                              button: true,
                              child: ElevatedButton(
                                onPressed: () {},
            style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  foregroundColor: Colors.white,
            ),
                                child: const Text('재주문'),
                              ),
                            ),
                          ],
          ),
        ],
                    ),
                  ),
                );
              },
      ),
    );
  }
}
