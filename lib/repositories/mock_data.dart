import '../models/store.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../models/menu_option.dart';
import '../models/order.dart';
import '../models/address.dart';

class MockData {
  // Placeholder 이미지 URL
  static const String placeholderImage = 'https://via.placeholder.com/300';

  // 카테고리 목록
  static const List<Map<String, String>> categories = [
    {'name': '한식', 'icon': '🍚'},
    {'name': '치킨', 'icon': '🍗'},
    {'name': '분식', 'icon': '🍜'},
    {'name': '돈까스', 'icon': '🍖'},
    {'name': '족발/보쌈', 'icon': '🥩'},
    {'name': '중식', 'icon': '🥢'},
    {'name': '피자', 'icon': '🍕'},
    {'name': '햄버거', 'icon': '🍔'},
    {'name': '디저트', 'icon': '🍰'},
    {'name': '샐러드', 'icon': '🥗'},
  ];

  // 인기 검색어
  static const List<Map<String, dynamic>> popularSearches = [
    {'rank': 1, 'keyword': '마라탕', 'change': 1, 'isNew': false},
    {'rank': 2, 'keyword': '햄버거', 'change': 6, 'isNew': false},
    {'rank': 3, 'keyword': '닭발', 'change': 0, 'isNew': false},
    {'rank': 4, 'keyword': '치킨', 'change': -2, 'isNew': false},
    {'rank': 5, 'keyword': '피자', 'change': 3, 'isNew': false},
    {'rank': 6, 'keyword': '떡볶이', 'change': -1, 'isNew': false},
    {'rank': 7, 'keyword': '요아정', 'change': 0, 'isNew': true},
  ];

  // 가게 목록 더미 데이터
  static List<Store> getStores() {
    return [
      Store(
        id: 'store1',
        name: '맛있는 한식당',
        rating: 4.9,
        reviewCount: 118,
        thumbnailUrl: placeholderImage,
        distance: 0.8,
        deliveryTime: 33,
        minOrderPrice: 22000,
        isWow: true,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store2',
        name: '크리스피 치킨',
        rating: 4.7,
        reviewCount: 256,
        thumbnailUrl: placeholderImage,
        distance: 1.2,
        deliveryTime: 45,
        minOrderPrice: 18000,
        isWow: true,
        isDiscount: false,
        hasFreeDelivery: false,
      ),
      Store(
        id: 'store3',
        name: '맛있는 분식집',
        rating: 4.5,
        reviewCount: 89,
        thumbnailUrl: placeholderImage,
        distance: 0.5,
        deliveryTime: 25,
        minOrderPrice: 15000,
        isWow: false,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store4',
        name: '왕돈까스',
        rating: 4.8,
        reviewCount: 203,
        thumbnailUrl: placeholderImage,
        distance: 1.5,
        deliveryTime: 40,
        minOrderPrice: 20000,
        isWow: true,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store5',
        name: '족발보쌈 전문점',
        rating: 4.6,
        reviewCount: 167,
        thumbnailUrl: placeholderImage,
        distance: 2.0,
        deliveryTime: 50,
        minOrderPrice: 30000,
        isWow: false,
        isDiscount: false,
        hasFreeDelivery: false,
      ),
    ];
  }

  // 가게 상세 정보 (메뉴 포함)
  static Store getStoreDetail(String storeId) {
    final stores = getStores();
    final store = stores.firstWhere((s) => s.id == storeId);

    return Store(
      id: store.id,
      name: store.name,
      rating: store.rating,
      reviewCount: store.reviewCount,
      thumbnailUrl: store.thumbnailUrl,
      distance: store.distance,
      deliveryTime: store.deliveryTime,
      minOrderPrice: store.minOrderPrice,
      isWow: store.isWow,
      isDiscount: store.isDiscount,
      hasFreeDelivery: store.hasFreeDelivery,
      menus: _getMenuCategories(storeId),
    );
  }

  static List<MenuCategory> _getMenuCategories(String storeId) {
    return [
      MenuCategory(
        id: 'popular',
        title: '인기메뉴',
        items: [
          MenuItem(
            id: 'menu1',
            name: '혼술메뉴 - 숭어 (1인분)',
            price: 25000,
            description: '신선한 숭어회와 함께하는 혼술 세트',
            imageUrl: placeholderImage,
            reviewCount: 45,
            options: [
              MenuOption(id: 'opt1', title: '와사비 추가', price: 0),
              MenuOption(id: 'opt2', title: '소주 추가', price: 5000),
            ],
          ),
          MenuItem(
            id: 'menu2',
            name: '특선 한정 메뉴',
            price: 35000,
            description: '오늘의 특선 메뉴',
            imageUrl: placeholderImage,
            reviewCount: 32,
          ),
        ],
      ),
      MenuCategory(
        id: 'recommended',
        title: '추천메뉴',
        items: [
          MenuItem(
            id: 'menu3',
            name: '시즌 메뉴 A',
            price: 28000,
            description: '계절 한정 메뉴',
            imageUrl: placeholderImage,
            reviewCount: 28,
          ),
        ],
      ),
      MenuCategory(
        id: 'season',
        title: '계절메뉴',
        items: [
          MenuItem(
            id: 'menu4',
            name: '봄 특선',
            price: 30000,
            description: '봄 한정 메뉴',
            imageUrl: placeholderImage,
          ),
        ],
      ),
    ];
  }

  // 주문 내역
  static List<Order> getOrders() {
    return [
      Order(
        id: 'order1',
        storeId: 'store1',
        storeName: '맛있는 한식당',
        totalPrice: 45000,
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        status: '배달완료',
      ),
      Order(
        id: 'order2',
        storeId: 'store2',
        storeName: '크리스피 치킨',
        totalPrice: 32000,
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        status: '배달완료',
      ),
      Order(
        id: 'order3',
        storeId: 'store4',
        storeName: '왕돈까스',
        totalPrice: 28000,
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
        status: '배달완료',
      ),
    ];
  }

  // 주소 목록
  static List<Address> getAddresses() {
    return [
      Address(
        id: 'addr1',
        address: '경기도 안산시 상록구 반석로 8',
        detailAddress: '한양아파트 3동 307호',
        isDefault: true,
        type: AddressType.home,
        directions: null,
      ),
      Address(
        id: 'addr2',
        address: '강원특별자치도 강릉시 해안로 536',
        detailAddress: '3동 336호',
        isDefault: false,
        type: AddressType.other,
        directions: null,
      ),
      Address(
        id: 'addr3',
        address: '경기도 용인시 기흥구 덕영대로 1732',
        detailAddress: '경희대학교국제캠퍼스 학관 정문',
        isDefault: false,
        type: AddressType.other,
        directions: null,
      ),
    ];
  }
}

