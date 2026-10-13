import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class MemberRoleStyle {
  static Color background(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppPallete.primarySoft;
      case 'member':
      default:
        return AppPallete.pageBackground;
    }
  }

  static Color foreground(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppPallete.primary;
      case 'member':
      default:
        return AppPallete.textPrimary;
    }
  }

  static String label(String role) {
    if (role.isEmpty) return 'Member';
    return role[0].toUpperCase() + role.substring(1);
  }
}
