import 'package:flutter/material.dart';

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
            style: TextStyle(color: Colors.grey.shade600),
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
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: simpleEntries.map((entry) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _labelize(entry.key),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatValue(entry.value),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
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
