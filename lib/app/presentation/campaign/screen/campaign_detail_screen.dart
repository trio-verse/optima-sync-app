import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_bloc.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_event.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_state.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_bloc.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_state.dart';
import 'package:optima_sync_v2/app/presentation/campaign/pages/campaign_detail_widgets.dart';
import 'package:optima_sync_v2/app/presentation/campaign/pages/campaign_status_style.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_event.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_state.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/add_content_form.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/content_status_style.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';
import 'package:optima_sync_v2/service_locator.dart';

class CampaignDetailScreen extends StatelessWidget {
  final CampaignEntity campaign;

  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnalyticsBloc>(
      create: (_) =>
          AnalyticsBloc(usecases: sl())
            ..add(LoadCampaignAnalytics(campaignId: campaign.id!)),
      child: _CampaignDetailView(campaign: campaign),
    );
  }
}

class _CampaignDetailView extends StatefulWidget {
  final CampaignEntity campaign;

  const _CampaignDetailView({required this.campaign});

  @override
  State<_CampaignDetailView> createState() => _CampaignDetailViewState();
}

class _CampaignDetailViewState extends State<_CampaignDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<ContentBloc>().add(
      LoadContents(campaignId: widget.campaign.id!),
    );
  }

  Future<void> _refresh() async {
    context.read<AnalyticsBloc>().add(
      LoadCampaignAnalytics(campaignId: widget.campaign.id!),
    );
    context.read<ContentBloc>().add(
      LoadContents(campaignId: widget.campaign.id!),
    );
    await context.read<AnalyticsBloc>().stream.firstWhere(
      (s) => s is CampaignAnalyticsLoaded || s is AnalyticsFailure,
    );
  }

  void _openAddContent(String campaignId) {
    final bloc = context.read<ContentBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: AddContentForm(campaignId: campaignId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampaignBloc, CampaignState>(
      builder: (context, campaignState) {
        var current = widget.campaign;
        if (campaignState is CampaignSuccess) {
          current = campaignState.campaigns.firstWhere(
            (c) => c.id == widget.campaign.id,
            orElse: () => widget.campaign,
          );
        }

        return Scaffold(
          backgroundColor: AppPallete.pageBackground,
          appBar: AppBar(
            backgroundColor: AppPallete.cardBackground,
            surfaceTintColor: AppPallete.cardBackground,
            elevation: 0,
            title: const Text(
              'Campaign Details',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          body: BlocListener<ContentBloc, ContentState>(
            listener: (context, state) {
              if (state is ContentSuccess && state.message != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message!)));
              }
              if (state is ContentFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
              builder: (context, analyticsState) {
                final analytics = analyticsState is CampaignAnalyticsLoaded
                    ? analyticsState.analytics
                    : null;
                final loading =
                    analyticsState is AnalyticsLoading ||
                    analyticsState is AnalyticsInitial;

                return BlocBuilder<ContentBloc, ContentState>(
                  builder: (context, contentState) {
                    final contentsLoading =
                        contentState is ContentInitial ||
                        contentState is ContentLoading;
                    final contents = switch (contentState) {
                      ContentSuccess(:final contents) => contents,
                      ContentSubmitting(:final contents) => contents,
                      ContentFailure(:final contents) =>
                        contents ?? const <ContentEntity>[],
                      _ => const <ContentEntity>[],
                    };

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (loading)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: LinearProgressIndicator(minHeight: 2),
                            ),
                          _HeaderCard(campaign: current),
                          const SizedBox(height: 14),
                          _MetricsGrid(
                            campaign: current,
                            analytics: analytics,
                            contentCount: contents.length,
                          ),
                          const SizedBox(height: 14),
                          _StatusBreakdownCard(
                            contents: contents,
                            loading: contentsLoading,
                          ),
                          const SizedBox(height: 14),
                          _ChannelDistributionCard(
                            contents: contents,
                            loading: contentsLoading,
                          ),
                          const SizedBox(height: 22),
                          _PipelineSection(
                            campaignId: current.id!,
                            contents: contents,
                            loading: contentsLoading,
                            onAdd: () => _openAddContent(current.id!),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final CampaignEntity campaign;

  const _HeaderCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    final statusColor = campaign.status == 'active'
        ? AppPallete.salesPrimary
        : CampaignStatusStyle.color(campaign.status);

    Widget info(Widget a, Widget b) => Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ],
    );

    return DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              campaign.status.toUpperCase(),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            campaign.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppPallete.textPrimary,
            ),
          ),
          if (campaign.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              campaign.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppPallete.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppPallete.cardBorder),
          const SizedBox(height: 14),
          info(
            DetailInfoItem(
              icon: Icons.track_changes_outlined,
              color: kDetailIndigo,
              background: kDetailIndigoSoft,
              label: 'Target Audience',
              value: campaign.target.isEmpty ? '—' : campaign.target,
            ),
            DetailInfoItem(
              icon: Icons.calendar_today_outlined,
              color: AppPallete.salesGreen,
              background: kDetailGreenSoft,
              label: 'Start Date',
              value: formatDetailDate(campaign.startDate),
            ),
          ),
          const SizedBox(height: 14),
          info(
            DetailInfoItem(
              icon: Icons.event_outlined,
              color: AppPallete.salesOrange,
              background: kDetailOrangeSoft,
              label: 'End Date',
              value: formatDetailDate(campaign.endDate),
            ),
            DetailInfoItem(
              icon: Icons.schedule_outlined,
              color: AppPallete.salesPrimary,
              background: kDetailBlueSoft,
              label: 'Last Updated',
              value: formatDetailDate(campaign.updatedAt),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  final CampaignEntity campaign;
  final CampaignAnalyticsEntity? analytics;
  final int contentCount;

  const _MetricsGrid({
    required this.campaign,
    required this.analytics,
    required this.contentCount,
  });

  @override
  Widget build(BuildContext context) {
    final double spent = analytics?.spent ?? campaign.spent ?? 0.0;
    final connections = analytics?.connections ?? campaign.connections ?? 0;
    final wins = analytics?.wins ?? campaign.wins ?? 0;
    final revenue = analytics?.revenue ?? campaign.revenue;

    final double budget = campaign.expectedBudget ?? 0.0;
    final target = campaign.estimatedContentCount ?? 0;

    final budgetPct = budget > 0 ? spent / budget * 100 : 0.0;
    final contentPct = target > 0 ? contentCount / target * 100 : 0.0;

    final cpl =
        analytics?.cpl ??
        campaign.cpl ??
        (connections > 0 ? spent / connections : null);
    final winRate =
        analytics?.winRate ??
        campaign.winRate ??
        (connections > 0 ? wins / connections * 100 : 0.0);
    final roi =
        analytics?.roi ??
        campaign.roi ??
        (spent > 0 && revenue != null ? (revenue - spent) / spent * 100 : 0.0);

    final profitable = roi >= 0;

    const cardHeight = 218.0;

    final budgetCard = MetricCardShell(
      title: 'BUDGET UTILIZATION',
      icon: Icons.attach_money,
      iconColor: AppPallete.textSecondary,
      body: RingGauge(percent: budgetPct, color: kDetailIndigo),
      footer: [
        MetricFooterRow(label: 'Spent:', value: formatMoney(spent)),
        MetricFooterRow(label: 'Budget:', value: formatMoney(budget)),
      ],
    );

    final contentCard = MetricCardShell(
      title: 'CONTENT GOAL',
      icon: Icons.layers_outlined,
      iconColor: AppPallete.textSecondary,
      body: RingGauge(percent: contentPct, color: AppPallete.salesGreen),
      footer: [
        MetricFooterRow(label: 'Current:', value: '$contentCount Items'),
        MetricFooterRow(label: 'Target:', value: '$target Items'),
      ],
    );

    final revenueCard = MetricCardShell(
      title: 'REVENUE & ROI',
      icon: Icons.trending_up,
      iconColor: AppPallete.salesGreen,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            revenue != null && revenue > 0 ? formatMoney(revenue) : 'N/A',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DetailPill(
            icon: profitable ? Icons.north_east : Icons.south_east,
            text:
                'ROI: ${formatPercent(roi)} ${profitable ? 'Making Profit' : 'Losing Money'}',
            color: profitable ? AppPallete.salesGreen : Colors.red.shade600,
            background: profitable ? kDetailGreenSoft : Colors.red.shade50,
          ),
        ],
      ),
      footer: [
        MetricFooterRow(
          label: 'Cost Per Lead (CPL):',
          value: (connections > 0 && cpl != null) ? formatMoney(cpl) : 'N/A',
        ),
      ],
    );

    final conversionsCard = MetricCardShell(
      title: 'CONVERSIONS',
      icon: Icons.share_outlined,
      iconColor: AppPallete.salesPrimary,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$wins Wins',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DetailPill(
            text: 'Win Rate: ${formatPercent(winRate)}',
            color: AppPallete.salesPrimary,
            background: kDetailBlueSoft,
          ),
        ],
      ),
      footer: [
        MetricFooterRow(label: 'Count Connections:', value: '$connections'),
      ],
    );

    Widget row(Widget a, Widget b) => Row(
      children: [
        Expanded(
          child: SizedBox(height: cardHeight, child: a),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(height: cardHeight, child: b),
        ),
      ],
    );

    return Column(
      children: [
        row(budgetCard, contentCard),
        const SizedBox(height: 12),
        row(revenueCard, conversionsCard),
      ],
    );
  }
}

class _StatusBreakdownCard extends StatelessWidget {
  final List<ContentEntity> contents;
  final bool loading;

  const _StatusBreakdownCard({required this.contents, required this.loading});

  @override
  Widget build(BuildContext context) {
    final total = contents.length;

    return DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailSectionTitle(
            icon: Icons.pie_chart_outline,
            color: kDetailIndigo,
            title: 'CONTENT STATUS BREAKDOWN',
            trailing: '$total Total',
          ),
          const SizedBox(height: 16),
          for (final status in kCampaignDetailContentStatuses)
            DetailProgressRow(
              label: ContentStatusStyle.label(status),
              count: contents.where((c) => c.status == status).length,
              total: total,
              color: ContentStatusStyle.color(status),
            ),
        ],
      ),
    );
  }
}

class _ChannelDistributionCard extends StatelessWidget {
  final List<ContentEntity> contents;
  final bool loading;

  const _ChannelDistributionCard({
    required this.contents,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final c in contents) {
      final name = (c.channelName?.trim().isNotEmpty ?? false)
          ? c.channelName!.trim()
          : 'Unknown';
      counts[name] = (counts[name] ?? 0) + 1;
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return DetailCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DetailSectionTitle(
            icon: Icons.share_outlined,
            color: AppPallete.salesGreen,
            title: 'DISTRIBUTION BY CHANNEL',
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No channel distribution data',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppPallete.textSecondary,
                  ),
                ),
              ),
            )
          else
            for (final e in entries)
              DetailProgressRow(
                label: e.key,
                count: e.value,
                total: contents.length,
                color: AppPallete.salesGreen,
              ),
        ],
      ),
    );
  }
}

class _PipelineSection extends StatelessWidget {
  final String campaignId;
  final List<ContentEntity> contents;
  final bool loading;
  final VoidCallback onAdd;

  const _PipelineSection({
    required this.campaignId,
    required this.contents,
    required this.loading,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Campaign Content Pipeline',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppPallete.textPrimary,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: onAdd,
              style: FilledButton.styleFrom(
                backgroundColor: AppPallete.salesPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text(
                'Add Content',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (loading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final status in kCampaignDetailContentStatuses)
                  PipelineColumn(
                    status: status,
                    campaignId: campaignId,
                    items: contents.where((c) => c.status == status).toList(),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
