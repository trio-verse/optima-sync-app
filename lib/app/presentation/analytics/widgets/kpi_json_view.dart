import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/widgets/app_mobile_widgets.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class KpiJsonView extends StatelessWidget {
  final Map<String, dynamic> data;

  const KpiJsonView({super.key, required this.data});

  static String _labelize(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  static String _formatValue(dynamic value) {
    if (value == null) return '—';
    if (value is num) {
      if (value == value.roundToDouble()) return value.toInt().toString();
      return value.toStringAsFixed(2);
    }
    if (value is bool) return value ? 'Yes' : 'No';
    if (value is List) return '${value.length} item(s)';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: AppPallete.textSecondary),
          ),
        ),
      );
    }

    final simpleEntries = data.entries.where((e) => e.value is! Map).toList();
    final nestedEntries = data.entries.where((e) => e.value is Map).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (simpleEntries.isNotEmpty)
          AppMetricGrid(children: simpleEntries.map((entry) => AppSurface(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_labelize(entry.key), style: const TextStyle(fontSize: 13, color: AppPallete.textSecondary)),
              const SizedBox(height: 8),
              Text(_formatValue(entry.value), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            ]),
          )).toList()),
        for (final entry in nestedEntries) ...[
          const SizedBox(height: 16),
          Text(
            _labelize(entry.key),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 8),
          KpiJsonView(data: Map<String, dynamic>.from(entry.value as Map)),
        ],
      ],
    );
  }
}
