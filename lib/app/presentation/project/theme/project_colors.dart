import 'package:flutter/material.dart';

class ProjectColors {
  ProjectColors._();

  static const Color background = Color(0xFFF7F6FF);
  static const Color card = Colors.white;

  static const Color primary = Color(0xFF4B3BC2);
  static const Color primarySoft = Color(0xFFE9E7FB);
  static const Color tint = Color(0xFFF1F0FD);
  static const Color line = Color(0xFFE6E4F5);

  static const Color teal = Color(0xFF0B6B75);
  static const Color cyanSoft = Color(0xFFB9F0F8);

  static const Color title = Color(0xFF15152E);
  static const Color body = Color(0xFF45456A);
  static const Color muted = Color(0xFF8686A3);

  static const Color danger = Color(0xFFA11D14);
  static const Color dangerSoft = Color(0xFFFFE3E0);

  static const Color amber = Color(0xFFB45309);
  static const Color amberSoft = Color(0xFFFEF3C7);
  static const Color green = Color(0xFF047857);
  static const Color greenSoft = Color(0xFFD1FAE5);
  static const Color orange = Color(0xFFC2410C);
  static const Color orangeSoft = Color(0xFFFFEDD5);

  static const List<Color> chartPalette = [
    Color(0xFF4B3BC2),
    Color(0xFF0B6B75),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEC4899),
  ];

  static List<BoxShadow> get shadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.07),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.28),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static String statusLabel(String status) {
    if (status == 'deliverd') return 'Delivered';
    return status
        .split('_')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  static ProjectStatusStyle statusStyle(String status) {
    switch (status) {
      case 'completed':
      case 'deliverd':
      case 'accepted':
        return const ProjectStatusStyle(
          background: greenSoft,
          foreground: green,
        );
      case 'in_progress':
        return const ProjectStatusStyle(
          background: primarySoft,
          foreground: primary,
        );
      case 'under_review':
        return const ProjectStatusStyle(
          background: amberSoft,
          foreground: amber,
        );
      case 'on_hold':
        return const ProjectStatusStyle(
          background: orangeSoft,
          foreground: orange,
        );
      case 'rejected':
      case 'fail':
        return const ProjectStatusStyle(
          background: dangerSoft,
          foreground: danger,
        );
      default:
        return const ProjectStatusStyle(background: cyanSoft, foreground: teal);
    }
  }
}

class ProjectStatusStyle {
  final Color background;
  final Color foreground;

  const ProjectStatusStyle({
    required this.background,
    required this.foreground,
  });
}
