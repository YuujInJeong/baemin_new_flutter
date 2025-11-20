import '../models/store.dart';
import '../models/menu_category.dart';
import '../models/menu_item.dart';
import '../models/menu_option.dart';
import '../models/order.dart';
import '../models/address.dart';

class MockData {
  // Placeholder 이미지 URL - 실제 작동하는 이미지 사용
  static const String placeholderImage = 'https://picsum.photos/400/300?random=1';
  
  // 음식 이미지 URL들
  static const String chickenImage = 'https://picsum.photos/400/300?random=2';
  static const String burgerImage = 'https://picsum.photos/400/300?random=3';
  static const String pastaImage = 'https://picsum.photos/400/300?random=4';
  static const String seafoodImage = 'https://picsum.photos/400/300?random=5';
  static const String koreanFoodImage = 'https://picsum.photos/400/300?random=6';

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
        name: '프랑킨바베큐치킨 상복점',
        rating: 4.5,
        reviewCount: 176,
        thumbnailUrl: chickenImage,
        distance: 0.9,
        deliveryTime: 19,
        minOrderPrice: 15000,
        isWow: true,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store2',
        name: '버거킹 상록수',
        rating: 4.6,
        reviewCount: 2304,
        thumbnailUrl: burgerImage,
        distance: 1.2,
        deliveryTime: 25,
        minOrderPrice: 12000,
        isWow: false,
        isDiscount: true,
        hasFreeDelivery: false,
      ),
      Store(
        id: 'store3',
        name: '단칸방 파스타',
        rating: 4.9,
        reviewCount: 925,
        thumbnailUrl: pastaImage,
        distance: 0.2,
        deliveryTime: 17,
        minOrderPrice: 5000,
        isWow: true,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store4',
        name: '청춘아구찜&알곤이찜',
        rating: 4.9,
        reviewCount: 70,
        thumbnailUrl: seafoodImage,
        distance: 0.3,
        deliveryTime: 23,
        minOrderPrice: 12000,
        isWow: true,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store5',
        name: '지코바 본오1호점',
        rating: 4.9,
        reviewCount: 1501,
        thumbnailUrl: chickenImage,
        distance: 0.3,
        deliveryTime: 26,
        minOrderPrice: 9900,
        isWow: true,
        isDiscount: false,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store6',
        name: '갯바위횟집',
        rating: 4.9,
        reviewCount: 118,
        thumbnailUrl: seafoodImage,
        distance: 0.5,
        deliveryTime: 33,
        minOrderPrice: 22000,
        isWow: true,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store7',
        name: '명이나물훈제오리덮밥',
        rating: 4.5,
        reviewCount: 200,
        thumbnailUrl: koreanFoodImage,
        distance: 0.7,
        deliveryTime: 20,
        minOrderPrice: 9600,
        isWow: false,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store8',
        name: '강시네 순두부찌개',
        rating: 4.0,
        reviewCount: 1367,
        thumbnailUrl: koreanFoodImage,
        distance: 0.6,
        deliveryTime: 18,
        minOrderPrice: 9000,
        isWow: false,
        isDiscount: true,
        hasFreeDelivery: true,
      ),
      Store(
        id: 'store9',
        name: '[오픈 특개] 돼지고기김치찌개',
        rating: 4.7,
        reviewCount: 89,
        thumbnailUrl: koreanFoodImage,
        distance: 0.4,
        deliveryTime: 22,
        minOrderPrice: 10900,
        isWow: false,
        isDiscount: true,
        hasFreeDelivery: false,
      ),
      Store(
        id: 'store10',
        name: '크리스피후라이드',
        rating: 4.8,
        reviewCount: 342,
        thumbnailUrl: chickenImage,
        distance: 1.0,
        deliveryTime: 30,
        minOrderPrice: 19900,
        isWow: true,
        isDiscount: true,
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
    // 가게별로 다른 메뉴 제공
    switch (storeId) {
      case 'store1': // 프랑킨바베큐치킨
        return [
          MenuCategory(
            id: 'popular',
            title: '인기메뉴',
            items: [
              MenuItem(
                id: 'menu1_1',
                name: '프랑킨 오리지널 치킨',
                price: 18000,
                description: '바삭하고 촉촉한 프랑킨 시그니처 치킨',
                imageUrl: placeholderImage,
                reviewCount: 234,
                options: [
                  MenuOption(id: 'opt1_1', title: '양념 추가', price: 2000),
                  MenuOption(id: 'opt1_2', title: '콜라 추가', price: 2000),
                ],
              ),
              MenuItem(
                id: 'menu1_2',
                name: '프랑킨 양념 치킨',
                price: 19000,
                description: '달콤한 양념이 일품인 치킨',
                imageUrl: placeholderImage,
                reviewCount: 189,
              ),
            ],
          ),
          MenuCategory(
            id: 'set',
            title: '세트메뉴',
            items: [
              MenuItem(
                id: 'menu1_3',
                name: '치킨+콜라 세트',
                price: 21000,
                description: '치킨과 콜라가 함께',
                imageUrl: placeholderImage,
                reviewCount: 156,
              ),
            ],
          ),
        ];
      case 'store2': // 버거킹
        return [
          MenuCategory(
            id: 'burger',
            title: '버거',
            items: [
              MenuItem(
                id: 'menu2_1',
                name: '와퍼',
                price: 6900,
                description: '불고기 패티가 들어간 클래식 버거',
                imageUrl: placeholderImage,
                reviewCount: 1234,
                options: [
                  MenuOption(id: 'opt2_1', title: '치즈 추가', price: 1000),
                  MenuOption(id: 'opt2_2', title: '베이컨 추가', price: 2000),
                ],
              ),
              MenuItem(
                id: 'menu2_2',
                name: '치즈버거',
                price: 4900,
                description: '고소한 치즈가 듬뿍',
                imageUrl: placeholderImage,
                reviewCount: 892,
              ),
            ],
          ),
        ];
      case 'store3': // 단칸방 파스타
        return [
          MenuCategory(
            id: 'pasta',
            title: '파스타',
            items: [
              MenuItem(
                id: 'menu3_1',
                name: '크림 파스타',
                price: 12000,
                description: '부드러운 크림 소스의 파스타',
                imageUrl: placeholderImage,
                reviewCount: 456,
                options: [
                  MenuOption(id: 'opt3_1', title: '치즈 추가', price: 2000),
                  MenuOption(id: 'opt3_2', title: '베이컨 추가', price: 3000),
                ],
              ),
              MenuItem(
                id: 'menu3_2',
                name: '토마토 파스타',
                price: 11000,
                description: '신선한 토마토 소스',
                imageUrl: placeholderImage,
                reviewCount: 389,
              ),
            ],
          ),
        ];
      default:
        return [
          MenuCategory(
            id: 'popular',
            title: '인기메뉴',
            items: [
              MenuItem(
                id: 'menu_default_1',
                name: '시그니처 메뉴',
                price: 15000,
                description: '이 가게의 대표 메뉴',
                imageUrl: placeholderImage,
                reviewCount: 50,
                options: [
                  MenuOption(id: 'opt_default_1', title: '추가 옵션', price: 2000),
                ],
              ),
            ],
          ),
        ];
    }
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

