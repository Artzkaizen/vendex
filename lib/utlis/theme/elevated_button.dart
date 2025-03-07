import 'package:flutter/material.dart';

class VendxElevatedButton {
  VendxElevatedButton._();

  static ElevatedButtonThemeData _createButtonTheme(
      {required Color backgroundColor, required Color foregroundColor}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: backgroundColor.withOpacity(0.5),
        disabledBackgroundColor: backgroundColor.withOpacity(0.5),
        side: BorderSide(color: backgroundColor),
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        textStyle: TextStyle(
          fontSize: 16.0,
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  static final ElevatedButtonThemeData light = _createButtonTheme(
      backgroundColor: const Color(0xFF0A6ACB), foregroundColor: Colors.white);
  static final ElevatedButtonThemeData dark = _createButtonTheme(
      backgroundColor: const Color(0xFF0A6ACB), foregroundColor: Colors.black);
}
