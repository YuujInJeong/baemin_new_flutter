import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final String icon;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$name 카테고리 버튼',
      hint: '누르시면 $name 카테고리 가게 목록 화면으로 이동합니다.',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 70,
          margin: const EdgeInsets.only(right: 12), // 간격 12dp
          child: Column(
            children: [
              Semantics(
                label: '$name 카테고리 아이콘',
                image: true,
                child: Container(
                  width: 56, // 56dp 원형 이미지
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.bgGray,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12), // 12dp 간격
              Semantics(
                label: '카테고리명',
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12, // 텍스트 12dp
                    color: AppTheme.textBlack,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
