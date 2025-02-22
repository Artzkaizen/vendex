import 'package:flutter/material.dart';

class BottomNavRoute {
  const BottomNavRoute(
      {required this.label, required this.icon, required this.activeIcon});

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const resetPassword = '/reset-password';
  static const forgotPassword = '/forgot-password';

  static const home = '/home';
  static const orders = '/orders';
  static const profile = '/profile';
  static const favourites = '/favourites';
  static const success = '/success';

  static const cart = '/cart';
  static const product = '/product:id';
  static const category = '/category/:id';
  static const orderDetails = '/order-details/:orderId';

  static const bottomNavRoutes = <BottomNavRoute>[
    BottomNavRoute(
        label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
    BottomNavRoute(
        label: 'Orders',
        icon: Icons.published_with_changes,
        activeIcon: Icons.published_with_changes),
    BottomNavRoute(
        label: 'Favourites',
        icon: Icons.favorite_border_outlined,
        activeIcon: Icons.favorite),
    BottomNavRoute(
        label: 'Profile', icon: Icons.person_outline, activeIcon: Icons.person),
  ];
}
