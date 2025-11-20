import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address.dart';
import '../repositories/mock_data.dart';

final addressProvider = StateNotifierProvider<AddressNotifier, Address?>((ref) {
  return AddressNotifier();
});

class AddressNotifier extends StateNotifier<Address?> {
  AddressNotifier() : super(MockData.getAddresses().firstWhere((a) => a.isDefault)) {
    _loadAddresses();
  }

  void _loadAddresses() {
    final addresses = MockData.getAddresses();
    state = addresses.firstWhere((a) => a.isDefault);
  }

  void setAddress(Address address) {
    state = address;
  }

  void addAddress(Address address) {
    // 실제로는 리포지토리에 추가해야 하지만, 여기서는 상태만 업데이트
    setAddress(address);
  }

  void updateAddress(Address address) {
    // 실제로는 리포지토리에 업데이트해야 하지만, 여기서는 상태만 업데이트
    setAddress(address);
  }
}

