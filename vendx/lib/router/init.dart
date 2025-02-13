 import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:vendx/features/auth/view/screens/login.dart';
import 'package:vendx/features/auth/view/screens/onboarding.dart';
import 'package:vendx/features/auth/view/screens/signup.dart';

import 'package:vendx/features/cart/view/screens/cart.dart';
import 'package:vendx/features/home/view/screens/user.dart';
import 'package:vendx/features/orders/model/order.dart';
import 'package:vendx/features/orders/view/screens/orders.dart';
import 'package:vendx/features/orders/view/screens/new.dart';
import 'package:vendx/features/product/model/products.dart';

import 'package:vendx/features/home/view/screens/favourites.dart';
import 'package:vendx/features/home/view/screens/home.dart';

import 'package:vendx/features/home/view/screens/product_screen.dart';

import 'package:vendx/router/routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

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

sealed class RouteLocation {
  final String path;
  final Map<String, String>? params;
  final Map<String, String>? queryParams;

  const RouteLocation({
    required this.path,
    this.params,
    this.queryParams,
  });

  String get location {
    String location = path;

    if (params != null) {
      params!.forEach((key, value) {
        location = location.replaceAll(':$key', value);
      });
    }

    if (queryParams != null && queryParams!.isNotEmpty) {
      location += '?';
      location += queryParams!.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    return location;
  }
}

class AppRoute extends RouteLocation {
  const AppRoute({
    required super.path,
    super.params,
    super.queryParams,
  });
}

class AppRoutes {
  // Auth

  static const login = LoginRoute();
  static const signup = SignupRoute();
  static const resetPassword = ResetPasswordRoute();
  static const forgotPassword = ForgotPasswordRoute();

  static const home = HomeRoute();
  static const cart = CartRoute();

  static const orders = OrdersRoute();

  static const profile = ProfileRoute();
  static const success = SuccessRoute();

  static ProductRoute product({required String id, String? category}) =>
      ProductRoute(id: id, category: category);

  static CategoryRoute category({required String id}) => CategoryRoute(id: id);

  static OrderDetailsRoute orderDetails({required String orderId}) =>
      OrderDetailsRoute(orderId: orderId);
}

class HomeRoute extends AppRoute {
  const HomeRoute() : super(path: '/home');
}

class ProductRoute extends AppRoute {
  ProductRoute({
    required String id,
    String? category,
  }) : super(
          path: '/product/:id',
          params: {'id': id},
          queryParams: category != null ? {'category': category} : null,
        );
}

class CategoryRoute extends AppRoute {
  CategoryRoute({required String id})
      : super(
          path: '/category/:id',
          params: {'id': id},
        );
}

class CartRoute extends AppRoute {
  const CartRoute() : super(path: '/cart');
}

class SignupRoute extends AppRoute {
  const SignupRoute() : super(path: '/auth/sign-up');
}

class LoginRoute extends AppRoute {
  const LoginRoute() : super(path: '/auth/login');
}

class ForgotPasswordRoute extends AppRoute {
  const ForgotPasswordRoute() : super(path: '/auth/forgot-password');
}

class SuccessRoute extends AppRoute {
  const SuccessRoute() : super(path: '/success');
}

class ResetPasswordRoute extends AppRoute {
  const ResetPasswordRoute() : super(path: '/auth/reset-password');
}

class OrdersRoute extends AppRoute {
  const OrdersRoute() : super(path: '/orders');
}

class ProfileRoute extends AppRoute {
  const ProfileRoute() : super(path: '/profile');
}

class OrderDetailsRoute extends AppRoute {
  OrderDetailsRoute({required String orderId})
      : super(
          path: '/orders/:orderId',
          params: {'orderId': orderId},
        );
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
        path: AppRoutes.login.path,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup.path,
        builder: (BuildContext context, GoRouterState state) =>
            const SignupScreen(),
      ),
      GoRoute(
        name: Routes.cartPage,
        path: Routes.cartPage,
        builder: (context, state) => CartScreen(),
      ),
      GoRoute(
        name: AppRoutes.success.path,
        path: AppRoutes.success.path,
        builder: (context, state) => CartScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => LayoutScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: AppRoutes.home.path,
                  builder: (context, state) => const HomeScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: Routes.products,
                      path: Routes.products,
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
                  path: AppRoutes.orders.path,
                  builder: (context, state) => OrdersScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: Routes.orderDetails,
                      path: Routes.orderDetails,
                      builder: (context, state) => SingleOrderScreen(
                        order: state.extra as OrderModel,
                      ),
                    )
                  ]),
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
                path: Routes.userPage,
                builder: (context, state) => const UserScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    // errorBuilder: (context, state) => const NotFoundPage(),
  );

  static void push(BuildContext context, RouteLocation route) {
    context.push(route.location);
  }

  static void go(BuildContext context, RouteLocation route) {
    context.go(route.location);
  }

  static void replace(BuildContext context, RouteLocation route) {
    context.replace(route.location);
  }

  static void pop(BuildContext context) {
    context.pop();
  }
}
