import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class ContentStatusStyle {
  static Color color(String status) {
    switch (status) {
      case 'in_review':
        return AppPallete.warning;
      case 'approved':
        return AppPallete.primary;
      case 'rejected':
        return AppPallete.danger;
      case 'published':
        return AppPallete.success;
      case 'draft':
      default:
        return AppPallete.textSecondary;
    }
  }

  static String label(String status) {
    switch (status) {
      case 'in_review':
        return 'In Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'published':
        return 'Published';
      case 'draft':
      default:
        return 'Draft';
    }
  }

  static IconData icon(String status) {
    switch (status) {
      case 'in_review':
        return Icons.hourglass_top_outlined;
      case 'approved':
        return Icons.verified_outlined;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'published':
        return Icons.public_outlined;
      case 'draft':
      default:
        return Icons.edit_note_outlined;
    }
  }
}
