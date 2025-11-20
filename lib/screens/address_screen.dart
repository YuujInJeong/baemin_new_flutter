import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/address_provider.dart';
import '../repositories/mock_data.dart';
import '../models/address.dart';

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = MockData.getAddresses();
    final currentAddress = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgGray,
      appBar: AppBar(
        title: const Text('주소관리'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final address = addresses[index];
          final isSelected = currentAddress?.id == address.id;
          return Semantics(
            label: '주소 선택 버튼',
            hint: '주소: ${address.fullAddress}. ${isSelected ? "현재 선택된 주소입니다." : "누르시면 이 주소로 설정됩니다."}',
            button: true,
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Semantics(
                  label: '주소',
                  child: Text(
                    address.address,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textBlack,
                    ),
                  ),
                ),
                subtitle: Semantics(
                  label: '상세 주소',
                  child: Text(
                    address.detailAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textGray,
                    ),
                  ),
                ),
                trailing: isSelected
                    ? Semantics(
                        label: '선택된 주소 표시',
                        image: true,
                        child: const Icon(Icons.check_circle, color: AppTheme.primaryBlue),
                      )
                    : null,
                onTap: () {
                  ref.read(addressProvider.notifier).setAddress(address);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Semantics(
        label: '주소 추가 버튼',
        hint: '누르시면 새 주소를 추가할 수 있습니다.',
        button: true,
        child: FloatingActionButton(
          onPressed: () {
            // 주소 추가 화면으로 이동 (구현 생략)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('주소 추가 기능은 구현되지 않았습니다')),
            );
          },
          backgroundColor: AppTheme.primaryBlue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

