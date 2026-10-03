import 'package:flutter/material.dart';

class MemberRoleStyle {
  static Color background(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color(0xFFEDE9FE);
      case 'member':
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  static Color foreground(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return const Color(0xFF6D28D9);
      case 'member':
      default:
        return const Color(0xFF374151);
    }
  }

  static String label(String role) {
    if (role.isEmpty) return 'Member';
    return role[0].toUpperCase() + role.substring(1);
  }
}
