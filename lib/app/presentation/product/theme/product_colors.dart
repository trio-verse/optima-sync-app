import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

/// Existing product color names share the application Dashboard palette.
class ProductColors {
  ProductColors._();

  static const Color background = AppPallete.pageBackground;
  static const Color cardBackground = AppPallete.cardBackground;
  static const Color cardBorder = AppPallete.cardBorder;

  static const Color primary = AppPallete.primary;
  static const Color primaryDark = AppPallete.primary;

  static const List<Color> heroIconGradient = [
    AppPallete.primary,
    AppPallete.primary,
  ];

  static const Color titleText = AppPallete.textPrimary;
  static const Color subtitleText = AppPallete.textSecondary;
  static const Color bodyText = AppPallete.textPrimary;

  static const Color statBlueBg = AppPallete.primarySoft;
  static const Color statBlueFg = AppPallete.primary;

  static const Color statGreenBg = AppPallete.successSoft;
  static const Color statGreenFg = AppPallete.success;

  static const Color statPurpleBg = AppPallete.primarySoft;
  static const Color statPurpleFg = AppPallete.primary;

  static const Color priceBadgeBg = AppPallete.successSoft;
  static const Color priceBadgeFg = AppPallete.success;

  static const Color productIconBg = AppPallete.primarySoft;
  static const Color productIconFg = AppPallete.primary;

  static const Color inputBorder = AppPallete.cardBorder;
  static const Color inputFill = AppPallete.inputFill;

  static const Color requiredBadgeBg = AppPallete.inputFill;
  static const Color requiredBadgeFg = AppPallete.textSecondary;

  static const Color danger = AppPallete.danger;

  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
}
