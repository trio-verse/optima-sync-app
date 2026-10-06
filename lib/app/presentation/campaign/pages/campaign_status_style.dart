import 'package:flutter/material.dart';

class CampaignStatusStyle {
  static Color color(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'draft':
      default:
        return Colors.grey;
    }
  }

  static String label(String status) {
    if (status.isEmpty) return 'Draft';
    return status[0].toUpperCase() + status.substring(1);
  }
}
