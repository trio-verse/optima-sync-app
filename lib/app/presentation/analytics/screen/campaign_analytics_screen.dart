import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_bloc.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_event.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_state.dart';
import 'package:optima_sync_v2/app/presentation/analytics/widgets/kpi_json_view.dart';

class CampaignAnalyticsScreen extends StatefulWidget {
  final String campaignId;
  final String campaignName;

  const CampaignAnalyticsScreen({
    super.key,
    required this.campaignId,
    required this.campaignName,
  });

  @override
  State<CampaignAnalyticsScreen> createState() =>
      _CampaignAnalyticsScreenState();
}

class _CampaignAnalyticsScreenState extends State<CampaignAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(
      LoadCampaignAnalytics(campaignId: widget.campaignId),
    );
  }

  Future<void> _refresh() async {
    context.read<AnalyticsBloc>().add(
      LoadCampaignAnalytics(campaignId: widget.campaignId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.campaignName} · Analytics')),
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

          if (state is CampaignAnalyticsLoaded) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [KpiJsonView(data: state.analytics.raw)],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
