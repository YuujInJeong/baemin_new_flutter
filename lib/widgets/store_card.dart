import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/store.dart';
import 'package:intl/intl.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback? onTap;

  const StoreCard({
    super.key,
    required this.store,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final badges = <String>[];
    if (store.isWow) badges.add('WOW');
    if (store.isDiscount) badges.add('즉시할인');
    if (store.hasFreeDelivery) badges.add('무료배송');
    
    final badgeText = badges.isEmpty ? '' : badges.join(', ');
    final storeInfo = '평점 ${store.rating}점, 리뷰 ${store.reviewCount}개, 배달시간 ${store.deliveryTime}분, 최소주문 ${formatter.format(store.minOrderPrice)}원';
    
    return Semantics(
      label: '${store.name} 가게 카드',
      hint: '$storeInfo. ${badgeText.isNotEmpty ? "$badgeText 혜택이 있습니다. " : ""}누르시면 ${store.name} 가게 상세 화면으로 이동합니다.',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 240, // width 240dp
          height: 300, // height 300dp
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // radius 12dp
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 - height 160dp
              Stack(
                children: [
                  Semantics(
                    label: '${store.name} 가게 대표 이미지',
                    image: true,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        store.thumbnailUrl,
                        width: double.infinity,
                        height: 160, // top image height 160dp
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Semantics(
                            label: '${store.name} 가게 이미지 로드 실패',
                            image: true,
                            child: Container(
                              width: double.infinity,
                              height: 160,
                              color: AppTheme.bgGray,
                              child: const Icon(Icons.image, size: 48, color: AppTheme.textGray),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // 배지들
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        if (store.isWow)
                          Semantics(
                            label: 'WOW 배지',
                            hint: 'WOW 회원 혜택을 받을 수 있는 가게입니다.',
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.wowBlue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'WOW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (store.isDiscount) ...[
                          const SizedBox(width: 4),
                          Semantics(
                            label: '즉시할인 배지',
                            hint: '즉시할인 혜택이 적용되는 가게입니다.',
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '즉시할인',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              // 정보
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16), // padding 16dp
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 가게명
                      Semantics(
                        label: '가게명',
                        child: Text(
                          store.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textBlack,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 평점 + 리뷰수
                      Semantics(
                        label: '평점 ${store.rating}점, 리뷰 ${store.reviewCount}개',
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: AppTheme.yellow),
                            const SizedBox(width: 4),
                            Text(
                              '${store.rating}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textBlack,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${store.reviewCount})',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 시간 + 최소주문
                      Semantics(
                        label: '배달시간 ${store.deliveryTime}분, 최소주문금액 ${formatter.format(store.minOrderPrice)}원',
                        child: Row(
                          children: [
                            Text(
                              '${store.deliveryTime}분',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textGray,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '최소주문 ${formatter.format(store.minOrderPrice)}원',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (store.hasFreeDelivery) ...[
                        const SizedBox(height: 4),
                        Semantics(
                          label: '무료배송',
                          hint: '이 가게는 무료배송이 가능합니다.',
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.bgGray,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '무료배송',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
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
