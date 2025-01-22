import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:shop/utils/theme/bottom_sheet.dart';
// import 'package:shop/utils/theme/checkbox.dart';
// import 'package:shop/utils/theme/elevated_button.dart';
// import 'package:shop/utils/theme/outline_button.dart';
// import 'package:shop/utils/theme/text.dart';
// import 'package:shop/utils/theme/text_field.dart';
// import 'package:shop/utils/constants/colors.dart';
import 'package:vendx/utlis/constants/colors.dart';
import 'package:vendx/utlis/theme/elevated_button.dart';
import 'package:vendx/utlis/theme/text.dart';

class VendxAppTheme {
  VendxAppTheme._();

  static ThemeData _createAppTheme({
    required TextTheme textTheme,
    required Brightness brightness,
  }) {
    // Define colors based on brightness
    const primaryColor = VendxColors.primary900;
    final backgroundColor = brightness == Brightness.light
        ? VendxColors.neutral50
        : VendxColors.neutral900;
    final surfaceColor =
        brightness == Brightness.light ? Colors.white : VendxColors.neutral800;

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      brightness: brightness,
      textTheme: textTheme,

      // Colors
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,

      // Color Scheme
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: VendxColors.primary900,
        onPrimary: Colors.white,
        secondary: VendxColors.primary700,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: brightness == Brightness.light
            ? VendxColors.neutral900
            : VendxColors.neutral50,
      ),

      // Divider
      dividerColor: brightness == Brightness.light
          ? VendxColors.neutral200
          : VendxColors.neutral700,

      // Component Themes
      // checkboxTheme: brightness == Brightness.light
      //     ? ShopCheckboxTheme.light
      //     : ShopCheckboxTheme.dark,

      // bottomSheetTheme: brightness == Brightness.light
      //     ? ShopBottomSheetTheme.light
      //     : ShopBottomSheetTheme.dark,

      elevatedButtonTheme: brightness == Brightness.light
          ? VendxElevatedButton.light
          : VendxElevatedButton.dark,

      // inputDecorationTheme: brightness == Brightness.light
      //     ? VendxTextFormFieldTheme.light
      //     : VendxTextFormFieldTheme.dark,

      // outlinedButtonTheme: brightness == Brightness.light
      //     ? VendxOutlinedButtonTheme.light
      //     : VendxOutlinedButtonTheme.dark,

      // Card Theme
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: brightness == Brightness.light
              ? VendxColors.neutral900
              : VendxColors.neutral50,
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: brightness == Brightness.light
              ? VendxColors.neutral900
              : VendxColors.neutral50,
        ),
      ),
    );
  }

  static ThemeData light = _createAppTheme(
    textTheme: VendxTextTheme.light,
    brightness: Brightness.light,
  );

  static ThemeData dark = _createAppTheme(
    textTheme: VendxTextTheme.dark,
    brightness: Brightness.dark,
  );
}
