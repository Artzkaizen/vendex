import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vendx/features/auth/view/screens/login.dart';
import 'package:vendx/features/auth/view/screens/onboarding.dart';
import 'package:vendx/features/auth/view/screens/signup.dart';
import 'package:vendx/features/auth/view/widgets/auth_provider.dart';

import 'package:vendx/features/cart/view/screens/cart.dart';
import 'package:vendx/features/cart/view/screens/payment_success.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/features/orders/view/screens/orders.dart';

import 'package:vendx/features/orders/view/screens/new.dart';
import 'package:vendx/features/product/model/product.dart';

import 'package:vendx/features/home/view/screens/favourites.dart';
import 'package:vendx/features/home/view/screens/home.dart';

import 'package:vendx/features/home/view/screens/product_screen.dart';
import 'package:vendx/features/profile/view/screens/profile.dart';

import 'package:vendx/router/routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _ordersNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'orders');
final _favouritesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'favourites');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

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
          items: AppRoutes.bottomNavRoutes
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

class SharedLayout extends StatelessWidget {
  final Widget child;

  const SharedLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}

final class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) =>
            const Onboarding(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (BuildContext context, GoRouterState state) =>
            const SignupScreen(),
      ),
      GoRoute(
        name: AppRoutes.cart,
        path: AppRoutes.cart,
        builder: (context, state) => CartScreen(),
      ),
      GoRoute(
        name: AppRoutes.success,
        path: AppRoutes.success,
        builder: (context, state) => PaymentSuccessScreen(
          order: state.extra as OrderModel,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => LayoutScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                  name: AppRoutes.home,
                  path: AppRoutes.home,
                  builder: (context, state) => const HomeScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: AppRoutes.product,
                      path: AppRoutes.product,
                      builder: (context, state) => ProductScreen(
                        product: state.extra as ProductModel,
                      ),
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _ordersNavigatorKey,
            routes: [
              GoRoute(
                  path: AppRoutes.orders,
                  builder: (context, state) => OrdersScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: AppRoutes.orderDetails,
                      path: AppRoutes.orderDetails,
                      builder: (context, state) => SingleOrderScreen(
                        order: state.extra as OrderModel,
                      ),
                    )
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _favouritesNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.favourites,
                builder: (context, state) => const FavouritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.token != null && state.fullPath == '/login') {
        await authProvider.load();
        return '/home';
      }

      if (authProvider.token == null && state.fullPath != '/login') {
        // This is weird, but it's a workaround
        await authProvider.load();
        return '/login';
      }

      return null;
    },
    // errorBuilder: (context, state) => const NotFoundPage(),
  );

  static void push(BuildContext context, String route) {
    context.push(route);
  }

  static void go(BuildContext context, String route) {
    context.go(route);
  }

  static void replace(BuildContext context, String route) {
    context.replace(route);
  }

  static void pop(BuildContext context) {
    context.pop();
  }

  Map<String, String> getPathParams(BuildContext context) {
    return GoRouterState.of(context).pathParameters;
  }
}
