import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/my_screen.dart';
import '../screens/store_detail_screen.dart';
import '../screens/menu_option_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/address_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 메인 탭 네비게이션
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/my',
              builder: (context, state) => const MyScreen(),
            ),
          ],
        ),
      ],
    ),
    // 상세 화면들
    GoRoute(
      path: '/store/:storeId',
      builder: (context, state) {
        final storeId = state.pathParameters['storeId']!;
        return StoreDetailScreen(storeId: storeId);
      },
    ),
    GoRoute(
      path: '/store/:storeId/menu/:menuId',
      builder: (context, state) {
        final storeId = state.pathParameters['storeId']!;
        final menuId = state.pathParameters['menuId']!;
        return MenuOptionScreen(storeId: storeId, menuId: menuId);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/address',
      builder: (context, state) => const AddressScreen(),
    ),
  ],
);

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Semantics(
              label: '홈 탭',
              hint: navigationShell.currentIndex == 0 ? '현재 홈 화면입니다.' : '누르시면 홈 화면으로 이동합니다.',
              child: const Icon(Icons.home_outlined),
            ),
            activeIcon: Semantics(
              label: '홈 탭',
              hint: '현재 홈 화면입니다.',
              child: const Icon(Icons.home),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: '검색 탭',
              hint: navigationShell.currentIndex == 1 ? '현재 검색 화면입니다.' : '누르시면 검색 화면으로 이동합니다.',
              child: const Icon(Icons.search),
            ),
            activeIcon: Semantics(
              label: '검색 탭',
              hint: '현재 검색 화면입니다.',
              child: const Icon(Icons.search),
            ),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: '즐겨찾기 탭',
              hint: navigationShell.currentIndex == 2 ? '현재 즐겨찾기 화면입니다.' : '누르시면 즐겨찾기 화면으로 이동합니다.',
              child: const Icon(Icons.favorite_outline),
            ),
            activeIcon: Semantics(
              label: '즐겨찾기 탭',
              hint: '현재 즐겨찾기 화면입니다.',
              child: const Icon(Icons.favorite),
            ),
            label: '즐겨찾기',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: '주문내역 탭',
              hint: navigationShell.currentIndex == 3 ? '현재 주문내역 화면입니다.' : '누르시면 주문내역 화면으로 이동합니다.',
              child: const Icon(Icons.receipt_long_outlined),
            ),
            activeIcon: Semantics(
              label: '주문내역 탭',
              hint: '현재 주문내역 화면입니다.',
              child: const Icon(Icons.receipt_long),
            ),
            label: '주문내역',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'My 탭',
              hint: navigationShell.currentIndex == 4 ? '현재 My 화면입니다.' : '누르시면 My 화면으로 이동합니다.',
              child: const Icon(Icons.person_outline),
            ),
            activeIcon: Semantics(
              label: 'My 탭',
              hint: '현재 My 화면입니다.',
              child: const Icon(Icons.person),
            ),
            label: 'My',
          ),
        ],
      ),
    );
  }
}

