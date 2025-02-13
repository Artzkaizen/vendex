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
  static const String products = 'products';
  static const String ordersPage = '/orders';
  static const String success = '/success';
  static const String orderDetails = '/orders/details';
  static const String favoritePage = '/favorite';
  static const String userPage = '/user';

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
        label: 'User',
        icon: Icons.person_outline,
        activeIcon: Icons.person),
  ];
}
