import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/address.dart';
import '../providers/address_provider.dart';

class AddressSettingScreen extends ConsumerStatefulWidget {
  final Address? address; // 수정 모드일 경우 기존 주소
  final AddressType? initialType; // 초기 주소 타입

  const AddressSettingScreen({super.key, this.address, this.initialType});

  @override
  ConsumerState<AddressSettingScreen> createState() => _AddressSettingScreenState();
}

class _AddressSettingScreenState extends ConsumerState<AddressSettingScreen> {
  late TextEditingController _mainAddressController;
  late TextEditingController _detailAddressController;
  late TextEditingController _directionsController;
  AddressType _selectedType = AddressType.home;

  @override
  void initState() {
    super.initState();
    _mainAddressController = TextEditingController(
      text: widget.address?.address ?? '',
    );
    _detailAddressController = TextEditingController(
      text: widget.address?.detailAddress ?? '',
    );
    _directionsController = TextEditingController(
      text: widget.address?.directions ?? '',
    );
    _selectedType = widget.address?.type ?? widget.initialType ?? AddressType.home;
  }

  @override
  void dispose() {
    _mainAddressController.dispose();
    _detailAddressController.dispose();
    _directionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('주소 설정'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 지도 영역 (플레이스홀더)
            Semantics(
              label: '주소 선택 지도',
              hint: '지도에서 주소를 선택할 수 있습니다.',
              child: Container(
                height: 300,
                width: double.infinity,
                color: AppTheme.bgGray,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Semantics(
                            label: '지도 아이콘',
                            image: true,
                            child: const Icon(Icons.map, size: 64, color: AppTheme.textGray),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '지도 영역',
                            style: TextStyle(
                              color: AppTheme.textGray,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 핀 아이콘
                    Positioned(
                      top: 120,
                      left: MediaQuery.of(context).size.width / 2 - 20,
                      child: Semantics(
                        label: '위치 핀',
                        image: true,
                        child: const Icon(
                          Icons.location_on,
                          size: 40,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    // 핀 조정하기 버튼
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Semantics(
                        label: '핀 조정하기 버튼',
                        hint: '누르시면 지도에서 위치를 조정할 수 있습니다.',
                        button: true,
                        child: ElevatedButton(
                          onPressed: () {
                            // 핀 조정 기능 (구현 생략)
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.textBlack,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('핀 조정하기'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 주소 정보
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 메인 주소
                  Row(
                    children: [
                      Semantics(
                        label: '위치 아이콘',
                        image: true,
                        child: const Icon(Icons.location_on, color: AppTheme.primaryBlue, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Semantics(
                          label: '주소',
                          child: Text(
                            _mainAddressController.text.isEmpty
                                ? '주소를 선택하세요'
                                : _mainAddressController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textBlack,
                            ),
                          ),
                        ),
                      ),
                      Semantics(
                        label: '주소 수정 버튼',
                        hint: '누르시면 주소를 검색하여 변경할 수 있습니다.',
                        button: true,
                        child: TextButton(
                          onPressed: () {
                            // 주소 검색 화면으로 이동 (구현 생략)
                            _mainAddressController.text = '경기도 안산시 상록구 반석로 8';
                            setState(() {});
                          },
                          child: const Text(
                            '수정',
                            style: TextStyle(color: AppTheme.primaryBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // WOW 배지
                  Semantics(
                    label: 'WOW 무료배달 가능 지역',
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '무료배달 가능 지역',
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  // 상세 주소
                  Semantics(
                    label: '상세주소 입력',
                    hint: '동, 호수 등을 입력하세요',
                    textField: true,
                    child: TextField(
                      controller: _detailAddressController,
                      decoration: InputDecoration(
                        labelText: '상세주소',
                        hintText: '3동 307호',
                        suffixIcon: _detailAddressController.text.isNotEmpty
                            ? Semantics(
                                label: '상세주소 삭제 버튼',
                                button: true,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    _detailAddressController.clear();
                                    setState(() {});
                                  },
                                ),
                              )
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 길 안내
                  Semantics(
                    label: '길 안내 입력',
                    hint: '배달 시 참고할 길 안내 정보를 입력하세요',
                    textField: true,
                    child: TextField(
                      controller: _directionsController,
                      decoration: const InputDecoration(
                        labelText: '길 안내',
                        hintText: '예: 1층에 올리브영이 있는 오피스텔',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 주소 타입 선택
                  const Text(
                    '주소 타입',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textBlack,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton(
                          type: AddressType.home,
                          icon: Icons.home,
                          label: '집',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTypeButton(
                          type: AddressType.company,
                          icon: Icons.business,
                          label: '회사',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTypeButton(
                          type: AddressType.other,
                          icon: Icons.location_on,
                          label: '기타',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // 하단 버튼 공간
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
          label: '완료 버튼',
          hint: '누르시면 주소 설정이 완료됩니다.',
          button: true,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_mainAddressController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('주소를 입력해주세요')),
                  );
                  return;
                }

                final newAddress = Address(
                  id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  address: _mainAddressController.text,
                  detailAddress: _detailAddressController.text,
                  type: _selectedType,
                  directions: _directionsController.text.isEmpty ? null : _directionsController.text,
                  isDefault: widget.address?.isDefault ?? false,
                );

                ref.read(addressProvider.notifier).setAddress(newAddress);
                Navigator.pop(context);
                if (widget.address != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('주소가 수정되었습니다')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('주소가 추가되었습니다')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '완료',
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

  Widget _buildTypeButton({
    required AddressType type,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedType == type;
    return Semantics(
      label: '$label 주소 타입',
      hint: isSelected ? '현재 선택된 주소 타입입니다.' : '누르시면 $label 주소 타입으로 설정됩니다.',
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.borderGray,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textGray,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.textGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
