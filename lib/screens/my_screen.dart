import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('My 이츠'),
      ),
      body: ListView(
        children: [
          // WOW 멤버십 배너
          Semantics(
            label: 'WOW 멤버십 배너',
            hint: '누르시면 WOW 멤버십 상세 정보 화면으로 이동합니다.',
            button: true,
            child: GestureDetector(
              onTap: () {
                // WOW 멤버십 상세 화면으로 이동
              },
              child: Container(
                margin: const EdgeInsets.all(16),
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
                      label: '별 아이콘',
                      image: true,
                      child: const Icon(Icons.star, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            label: 'WOW 멤버십',
                            child: const Text(
                              'WOW 멤버십',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Semantics(
                            label: '멤버십 안내',
                            hint: '특별한 혜택을 받아보세요',
                            child: const Text(
                              '특별한 혜택을 받아보세요',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Semantics(
                      label: '이동 아이콘',
                      image: true,
                      child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 메뉴 리스트
          _buildMenuItem(
            context,
            icon: Icons.location_on,
            title: '주소관리',
            label: '주소관리 버튼',
            hint: '누르시면 주소 관리 화면으로 이동합니다.',
            onTap: () => context.push('/address'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.payment,
            title: '결제수단',
            label: '결제수단 버튼',
            hint: '누르시면 결제수단 관리 화면으로 이동합니다.',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.local_offer,
            title: '쿠폰함',
            label: '쿠폰함 버튼',
            hint: '누르시면 보유한 쿠폰 목록 화면으로 이동합니다.',
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.headset_mic,
            title: '고객센터',
            label: '고객센터 버튼',
            hint: '누르시면 고객센터 화면으로 이동합니다.',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String label,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Semantics(
        label: label,
        hint: hint,
        button: true,
        child: ListTile(
          leading: Semantics(
            label: '$title 아이콘',
            image: true,
            child: Icon(icon, color: AppTheme.primaryBlue),
          ),
          title: Semantics(
            label: '메뉴명',
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textBlack,
              ),
            ),
          ),
          trailing: Semantics(
            label: '이동 아이콘',
            image: true,
            child: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textGray),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

