import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class ProjectColors {
  ProjectColors._();

  static const Color background = AppPallete.pageBackground;
  static const Color card = AppPallete.cardBackground;

  static const Color primary = AppPallete.primary;
  static const Color primarySoft = AppPallete.primarySoft;
  static const Color tint = AppPallete.inputFill;
  static const Color line = AppPallete.cardBorder;

  static const Color teal = AppPallete.primary;
  static const Color cyanSoft = AppPallete.primarySoft;

  static const Color title = AppPallete.textPrimary;
  static const Color body = AppPallete.textPrimary;
  static const Color muted = AppPallete.textSecondary;

  static const Color danger = AppPallete.danger;
  static const Color dangerSoft = AppPallete.dangerSoft;

  static const Color amber = AppPallete.warning;
  static const Color amberSoft = AppPallete.warningSoft;
  static const Color green = AppPallete.success;
  static const Color greenSoft = AppPallete.successSoft;
  static const Color orange = AppPallete.warning;
  static const Color orangeSoft = AppPallete.warningSoft;

  static const List<Color> chartPalette = [
    AppPallete.primary,
    AppPallete.success,
    AppPallete.salesPurple,
    AppPallete.warning,
    AppPallete.danger,
    AppPallete.textSecondary,
  ];

  static List<BoxShadow> get shadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.07),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get buttonShadow => const [];

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
