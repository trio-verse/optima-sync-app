import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/presentation/marketing/analytics/bloc/analytics_bloc.dart';
import 'package:optima_sync_v2/app/presentation/marketing/analytics/widgets/kpi_json_view.dart';
import 'package:optima_sync_v2/app/presentation/marketing/marketing_messages.dart';

class CampaignAnalyticsScreen extends StatefulWidget {
  final CampaignEntity campaign;

  const CampaignAnalyticsScreen({super.key, required this.campaign});

  @override
  State<CampaignAnalyticsScreen> createState() => _CampaignAnalyticsScreenState();
}

class _CampaignAnalyticsScreenState extends State<CampaignAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(LoadCampaignAnalytics(campaign: widget.campaign));
  }

  // Future<void> _refresh() async {
  //   context.read<AnalyticsBloc>().add(LoadCampaignAnalytics(campaignId: widget.campaignId, campaign: null));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.campaign.name} · Analytics')),
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
                      state.failure.text(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<AnalyticsBloc>().add(LoadCampaignAnalytics(campaign: widget.campaign)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CampaignAnalyticsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [KpiJsonView(data: state.analytics.toMap())],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
