import 'package:flutter/material.dart';

class ContentStatusStyle {
  static Color color(String status) {
    switch (status) {
      case 'in_review':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'published':
        return Colors.green;
      case 'draft':
      default:
        return Colors.grey;
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
