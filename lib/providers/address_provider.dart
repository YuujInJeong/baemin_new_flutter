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
}

