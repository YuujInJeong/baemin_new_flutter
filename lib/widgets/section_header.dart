import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            label: '$title 섹션',
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textBlack,
              ),
            ),
          ),
          if (onSeeAll != null)
            Semantics(
              label: '전체보기 버튼',
              hint: '누르시면 $title 섹션의 전체 목록을 볼 수 있습니다.',
              button: true,
              child: GestureDetector(
                onTap: onSeeAll,
                child: Row(
                  children: const [
                    Text(
                      '전체보기',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textGray,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppTheme.textGray,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
