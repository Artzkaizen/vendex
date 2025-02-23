import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:vendx/features/auth/view/screens/login.dart';
import 'package:vendx/features/auth/view/screens/onboarding.dart';
import 'package:vendx/features/auth/view/screens/signup.dart';

import 'package:vendx/features/cart/view/screens/cart.dart';
import 'package:vendx/features/product/model/products.dart';

import 'package:vendx/features/home/view/screens/favourites.dart';
import 'package:vendx/features/home/view/screens/home.dart';
import 'package:vendx/features/home/view/screens/orders.dart';
import 'package:vendx/features/home/view/screens/product_screen.dart';

import 'package:vendx/features/home/view/screens/search_screen.dart';

import 'package:vendx/router/routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: "/",
      builder: (BuildContext context, GoRouterState state) =>
      const Onboarding(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (BuildContext context, GoRouterState state) =>
      const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/sign-up',
      builder: (BuildContext context, GoRouterState state) =>
      const SignupScreen(),
    ),
    GoRoute(
      name: 'cart-single',
      path: '/cart/single',
      builder: (context, state) => CartScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => SearchScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: Routes.homePage,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    name: 'products',
                    path: "/product",
                    builder: (context, state) => ProductScreen(
                      product: state.extra as ProductModel,
                    ),
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.ordersPage,
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.favoritePage,
              builder: (context, state) => const FavouritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.cartPage,
              builder: (context, state) => CartScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationShell.currentIndex,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: navigationShell.goBranch,
          items: Routes.bottomNavRoutes
              .map((destination) => BottomNavigationBarItem(
            icon: Icon(destination.icon),
            label: destination.label,
            activeIcon: Icon(destination.activeIcon),
          ))
              .toList(),
        ),
      ),
    );
  }
}
