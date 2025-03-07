import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendxTextTheme {
  static TextTheme _createTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: textColor,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: textColor,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
        color: textColor,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: textColor,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: textColor,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
        color: textColor,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
        color: textColor,
      ),
    );
  }

  static final TextTheme light = _createTextTheme(Colors.black);
  static final TextTheme dark = _createTextTheme(Colors.white);
}
