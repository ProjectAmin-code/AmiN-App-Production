import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF58CC02);
  static const Color secondary = Color(0xFFFFB020);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF4F8FF);

  static const Color surface = Colors.white;
  static const Color success = Color(0xFF2EAD63);
  static const Color warning = Color(0xFFF4A52E);
  static const Color danger = Color(0xFFE45832);
  static const Color textPrimary = Color(0xFF1D3557);
  static const Color textSecondary = Color(0xFF4A5568);
}

class AppRadii {
  const AppRadii._();

  static const double xs = 10;
  static const double sm = 14;
  static const double md = 18;
  static const double lg = 24;
  static const double pill = 99;
}

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> soft = [
    BoxShadow(color: Color(0x1A0B2748), blurRadius: 12, offset: Offset(0, 5)),
  ];

  static const List<BoxShadow> floaty = [
    BoxShadow(color: Color(0x220B2748), blurRadius: 16, offset: Offset(0, 8)),
  ];
}

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

class AppTypography {
  const AppTypography._();

  static const List<String> fallbackFamilies = [
    'Poppins',
    'Roboto',
    'Noto Sans',
    'Arial',
  ];

  static TextTheme buildTextTheme(TextTheme base) {
    TextStyle withFallback(TextStyle style) {
      return style.copyWith(
        fontFamily: 'Poppins',
        fontFamilyFallback: fallbackFamilies,
      );
    }

    return TextTheme(
      displayLarge: withFallback(
        base.displayLarge!.copyWith(fontWeight: FontWeight.w800),
      ),
      displayMedium: withFallback(
        base.displayMedium!.copyWith(fontWeight: FontWeight.w800),
      ),
      displaySmall: withFallback(
        base.displaySmall!.copyWith(fontWeight: FontWeight.w800),
      ),
      headlineLarge: withFallback(
        base.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
      ),
      headlineMedium: withFallback(
        base.headlineMedium!.copyWith(fontWeight: FontWeight.w800),
      ),
      headlineSmall: withFallback(
        base.headlineSmall!.copyWith(fontWeight: FontWeight.w800),
      ),
      titleLarge: withFallback(
        base.titleLarge!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
      titleMedium: withFallback(
        base.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      titleSmall: withFallback(
        base.titleSmall!.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      bodyLarge: withFallback(
        base.bodyLarge!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      bodyMedium: withFallback(
        base.bodyMedium!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      bodySmall: withFallback(
        base.bodySmall!.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
      labelLarge: withFallback(
        base.labelLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      labelMedium: withFallback(
        base.labelMedium!.copyWith(fontWeight: FontWeight.w700),
      ),
      labelSmall: withFallback(
        base.labelSmall!.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
