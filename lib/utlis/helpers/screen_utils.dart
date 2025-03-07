import 'package:flutter/material.dart';

class VendxScreenUtils {
  // Singleton instance
  static final VendxScreenUtils _instance = VendxScreenUtils._internal();
  factory VendxScreenUtils() => _instance;
  VendxScreenUtils._internal();

  // Static variables for dimensions
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _statusBarHeight;
  static late double _bottomBarHeight;
  static late double _devicePixelRatio;
  static bool _initialized = false;

  // Getter methods to ensure initialization
  static double get screenWidth {
    _checkInitialized();
    return _screenWidth;
  }

  static double get screenHeight {
    _checkInitialized();
    return _screenHeight;
  }

  static double get statusBarHeight {
    _checkInitialized();
    return _statusBarHeight;
  }

  static double get bottomBarHeight {
    _checkInitialized();
    return _bottomBarHeight;
  }

  static double get devicePixelRatio {
    _checkInitialized();
    return _devicePixelRatio;
  }

  // Initialization method
  void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
    _devicePixelRatio = mediaQuery.devicePixelRatio;
    _initialized = true;
  }

  // Check if initialized
  static void _checkInitialized() {
    if (!_initialized) {
      throw Exception(
          'ScreenUtils not initialized. Please call ScreenUtils().init(context) in your widget tree before using it.');
    }
  }

  // Get height based on percentage
  static double height(double percentage) {
    _checkInitialized();
    return (screenHeight * percentage) / 100;
  }

  // Get width based on percentage
  static double width(double percentage) {
    _checkInitialized();
    return (screenWidth * percentage) / 100;
  }

  // Get height considering safe area
  static double safeHeight(BuildContext context, double percentage) {
    _checkInitialized();
    final safePadding = MediaQuery.of(context).padding;
    final safeHeight = screenHeight - safePadding.top - safePadding.bottom;
    return (safeHeight * percentage) / 100;
  }

  // Get width considering safe area
  static double safeWidth(BuildContext context, double percentage) {
    _checkInitialized();
    final safePadding = MediaQuery.of(context).padding;
    final safeWidth = screenWidth - safePadding.left - safePadding.right;
    return (safeWidth * percentage) / 100;
  }

  // Check if device is tablet
  static bool isTablet() {
    _checkInitialized();
    final shortestSide =
        screenWidth < screenHeight ? screenWidth : screenHeight;
    return shortestSide >= 600;
  }

  // Check if device is in landscape mode
  static bool isLandscape() {
    _checkInitialized();
    return screenWidth > screenHeight;
  }
}
