import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class CampaignStatusStyle {
  static Color color(String status) {
    switch (status) {
      case 'active':
        return AppPallete.success;
      case 'paused':
        return AppPallete.warning;
      case 'completed':
        return AppPallete.primary;
      case 'cancelled':
        return AppPallete.danger;
      case 'draft':
      default:
        return AppPallete.textSecondary;
    }
  }

  static String label(String status) {
    if (status.isEmpty) return 'Draft';
    return status[0].toUpperCase() + status.substring(1);
  }
}
