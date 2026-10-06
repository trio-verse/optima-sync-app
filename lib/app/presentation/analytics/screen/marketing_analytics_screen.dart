import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_bloc.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_event.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_state.dart';
import 'package:optima_sync_v2/app/presentation/analytics/widgets/kpi_json_view.dart';

class MarketingAnalyticsScreen extends StatefulWidget {
  const MarketingAnalyticsScreen({super.key});

  @override
  State<MarketingAnalyticsScreen> createState() =>
      _MarketingAnalyticsScreenState();
}

class _MarketingAnalyticsScreenState extends State<MarketingAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(LoadMarketingDashboard());
  }

  Future<void> _refresh() async {
    context.read<AnalyticsBloc>().add(LoadMarketingDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketing Analytics')),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading || state is AnalyticsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalyticsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _refresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is MarketingDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  KpiJsonView(data: state.dashboard.raw),
                  const SizedBox(height: 24),
                  const Text(
                    'Most Effective Campaigns',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.effectiveCampaigns.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No campaign data yet.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  else
                    ...state.effectiveCampaigns.map((campaign) {
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                campaign.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              KpiJsonView(data: campaign.raw),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
