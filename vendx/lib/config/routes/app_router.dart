import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vendx/features/auth/view/screens/forgot_password.dart';
import 'package:vendx/features/auth/view/screens/login.dart';

import 'package:vendx/features/auth/view/screens/onboarding.dart';
import 'package:vendx/features/auth/view/screens/reset_password.dart';
import 'package:vendx/features/auth/view/screens/signup.dart';
// import 'package:vendx/features/auth/view/screens/signup.dart';

import 'package:vendx/features/home/view/screens/main.dart';

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
  static const profile = ProfileRoute();

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

class ResetPasswordRoute extends AppRoute {
  const ResetPasswordRoute() : super(path: '/auth/reset-password');
}

class DetailsRoute extends AppRoute {
  const DetailsRoute() : super(path: '/details');
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
    routes: [
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) =>
            const Onboarding(),
      ),
      GoRoute(
        path: AppRoutes.home.path,
        builder: (BuildContext context, GoRouterState state) =>
            const SharedLayout(child: HomePage()),
      ),
      GoRoute(
        path: AppRoutes.signup.location,
        builder: (BuildContext context, GoRouterState state) =>
            const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.login.location,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword.location,
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword.location,
        builder: (BuildContext context, GoRouterState state) =>
            const ResetPasswordScreen(),
      ),
      // GoRoute(
      //   path: const ProductRoute(id: ':id').path,
      //   builder: (context, state) {
      //     final productId = state.pathParameters['id']!;
      //     final category = state.uri.queryParameters['category'];

      //     return ProductDetailPage(
      //       productId: productId,
      //       category: category,
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: const CategoryRoute(id: ':id').path,
      //   builder: (context, state) {
      //     final categoryId = state.pathParameters['id']!;
      //     return CategoryPage(categoryId: categoryId);
      //   },
      // ),
      // GoRoute(
      //   path: const CartRoute().path,
      //   builder: (context, state) => const CartPage(),
      // ),
      // GoRoute(
      //   path: const ProfileRoute().path,
      //   builder: (context, state) => const ProfilePage(),
      // ),
      // GoRoute(
      //   path: const OrderDetailsRoute(orderId: ':orderId').path,
      //   builder: (context, state) {
      //     final orderId = state.pathParameters['orderId']!;
      //     return OrderDetailsPage(orderId: orderId);
      //   },
      // ),
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
