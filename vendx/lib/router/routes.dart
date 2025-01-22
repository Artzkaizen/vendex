import 'package:flutter/material.dart';

class BottomNavRoute {
  const BottomNavRoute(
      {required this.label, required this.icon, required this.activeIcon});

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class Routes {
  Routes._();
  static const String cartPage = '/cart';
  static const String homePage = '/home';
  static const String productPage = 'products';
  static const String ordersPage = '/orders';
  static const String favoritePage = '/favorite';
  // static const String settingsPage = '/settings';
  // static const String nestedProfilePage = '/settings/profile';

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
        label: 'Cart',
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart),
  ];
}
