import 'package:flutter/material.dart';

/// Colors and gradients matching the OptimaSync "Products & Services"
/// dashboard design, so the mobile screens look consistent with the web app.
class ProductColors {
  ProductColors._();

  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  static const Color cardBorder = Color(0xFFEDEDF0);

  static const Color primary = Color(0xFF155DFC);
  static const Color primaryDark = Color(0xFF1D4ED8);

  static const List<Color> heroIconGradient = [
    Color(0xFF5B6EF5),
    Color(0xFF1D4ED8),
  ];

  static const Color titleText = Color(0xFF18181B);
  static const Color subtitleText = Color(0xFF71717A);
  static const Color bodyText = Color(0xFF3F3F46);

  static const Color statBlueBg = Color(0xFFEAF2FF);
  static const Color statBlueFg = Color(0xFF2563EB);

  static const Color statGreenBg = Color(0xFFE6F9F1);
  static const Color statGreenFg = Color(0xFF009966);

  static const Color statPurpleBg = Color(0xFFF3E8FF);
  static const Color statPurpleFg = Color(0xFF9333EA);

  static const Color priceBadgeBg = Color(0xFFE6F9F1);
  static const Color priceBadgeFg = Color(0xFF0F9D68);

  static const Color productIconBg = Color(0xFFEEF0F4);
  static const Color productIconFg = Color(0xFF52525B);

  static const Color inputBorder = Color(0xFFE4E4E7);
  static const Color inputFill = Colors.white;

  static const Color requiredBadgeBg = Color(0xFFF1F1F3);
  static const Color requiredBadgeFg = Color(0xFF52525B);

  static const Color danger = Color(0xFFDC2626);

  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
}
