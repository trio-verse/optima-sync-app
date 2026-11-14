import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/presentation/marketing/analytics/widgets/bar_graph/bar_chart.dart';

class CostsSection extends StatelessWidget {
  const CostsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text("Spent VS Revenue", style: TextStyle(fontWeight: .bold, fontSize: 18)),
          Text("Total marketing spend compared to revenue from won deals"),
          BarChartGraph(),
        ],
      ),
    );
  }
}
