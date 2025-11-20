import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        itemCount: addresses.length + 1, // +1 for "회사 추가" 버튼
        itemBuilder: (context, index) {
          if (index == 1) {
            // 회사 추가 버튼
            return Semantics(
              label: '회사 주소 추가 버튼',
              hint: '누르시면 회사 주소를 추가할 수 있습니다.',
              button: true,
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Semantics(
                    label: '회사 아이콘',
                    image: true,
                    child: const Icon(Icons.business, color: AppTheme.textGray),
                  ),
                  title: const Text(
                    '회사 추가',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textBlack,
                    ),
                  ),
                  onTap: () {
                    context.push('/address/setting', extra: {'type': AddressType.company});
                  },
                ),
              ),
            );
          }

          final address = addresses[index > 1 ? index - 1 : index];
          final isSelected = currentAddress?.id == address.id;
          
          return Semantics(
            label: '${address.typeLabel} 주소 선택 버튼',
            hint: '주소: ${address.fullAddress}. ${isSelected ? "현재 선택된 주소입니다." : "누르시면 이 주소로 설정됩니다."}',
            button: true,
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Semantics(
                  label: '${address.typeLabel} 아이콘',
                  image: true,
                  child: Icon(
                    address.type == AddressType.home
                        ? Icons.home
                        : address.type == AddressType.company
                            ? Icons.business
                            : Icons.location_on,
                    color: isSelected ? AppTheme.primaryBlue : AppTheme.textGray,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            label: '주소 타입',
                            child: Text(
                              address.typeLabel,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textGray,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Semantics(
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
                          if (address.detailAddress.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Semantics(
                              label: '상세 주소',
                              child: Text(
                                address.detailAddress,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ),
                          ],
                          if (address.directions != null && address.directions!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Semantics(
                              label: '길 안내',
                              child: Text(
                                address.directions!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textGray,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Semantics(
                            label: 'WOW 무료배달 가능 지역',
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'WOW',
                                    style: TextStyle(
                                      color: AppTheme.primaryBlue,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '무료배달 가능 지역',
                                    style: TextStyle(
                                      color: AppTheme.primaryBlue,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Semantics(
                        label: '선택된 주소 표시',
                        image: true,
                        child: const Icon(Icons.check_circle, color: AppTheme.primaryBlue),
                      ),
                    const SizedBox(width: 8),
                    Semantics(
                      label: '주소 수정 버튼',
                      hint: '누르시면 이 주소를 수정할 수 있습니다.',
                      button: true,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: AppTheme.textGray),
                        onPressed: () {
                          context.push('/address/setting', extra: {'address': address});
                        },
                      ),
                    ),
                  ],
                ),
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
            context.push('/address/setting');
          },
          backgroundColor: AppTheme.primaryBlue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

