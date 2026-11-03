import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/presentation/marketing/analytics/widgets/kpi_card.dart';

class KpiGridSection extends StatelessWidget {
  const KpiGridSection({super.key});
  final double spacing = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(spacing),
      child: Column(
        spacing: spacing,
        children: [
          Row(
            spacing: spacing,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: KpiCard(
                    title: 'ToTAL CAMPAIGNS',
                    subTitle: 'All campaigns',
                    value: 'value',
                    icon: Icons.layers_outlined,
                  ),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: KpiCard(title: 'ACTIVE', subTitle: 'Running campaigns', value: 'value', icon: Icons.abc),
                ),
              ),
            ],
          ),
          Row(
            spacing: spacing,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: KpiCard(
                    title: 'OVERALL CPL',
                    subTitle: 'Spent + connections',
                    value: 'value',
                    icon: Icons.layers_outlined,
                  ),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: KpiCard(
                    title: 'EXPECTED CONTENT',
                    subTitle: 'Sum across campaigns',
                    value: 'value',
                    icon: Icons.abc,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
