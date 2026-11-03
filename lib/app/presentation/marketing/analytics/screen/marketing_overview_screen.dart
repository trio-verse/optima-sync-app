import 'package:flutter/widgets.dart';
import 'package:optima_sync_v2/app/presentation/marketing/analytics/widgets/costs_section.dart';
import 'package:optima_sync_v2/app/presentation/marketing/analytics/widgets/kpi_grid_section.dart';
import 'package:optima_sync_v2/app/presentation/marketing/analytics/widgets/marketing_overview_section.dart';

class MarketingOverviewPage extends StatefulWidget {
  const MarketingOverviewPage({super.key});

  @override
  State<MarketingOverviewPage> createState() => _MarketingOverviewPageState();
}

class _MarketingOverviewPageState extends State<MarketingOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MarketingOverviewSection(onExport: () {}, onOverviewPressed: () {}),
          KpiGridSection(),
          CostsSection(),
        ],
      ),
    );
  }
}
