import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/campaign_usecases.dart';
import 'package:optima_sync_v2/app/presentation/analytics/utils/marketing_report_exporter.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_bloc.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_event.dart';
import 'package:optima_sync_v2/app/presentation/analytics/bloc/analytics_state.dart';
import 'package:optima_sync_v2/app/presentation/campaign/screen/campaign_screen.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';
import 'package:optima_sync_v2/core/widgets/app_drawer.dart';
import 'package:optima_sync_v2/service_locator.dart';

class MarketingOverviewScreen extends StatefulWidget {
  const MarketingOverviewScreen({super.key});

  @override
  State<MarketingOverviewScreen> createState() => _MarketingOverviewScreenState();
}

class _MarketingOverviewScreenState extends State<MarketingOverviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsBloc>().add(LoadMarketingDashboard());
  }

  Future<void> _refresh() async {
    context.read<AnalyticsBloc>().add(LoadMarketingDashboard());
    await context.read<AnalyticsBloc>().stream.firstWhere(
      (state) => state is MarketingDashboardLoaded || state is AnalyticsFailure,
    );
  }

  bool _exporting = false;

  Future<void> _export(
    MarketingDashboardEntity dashboard,
    List<EffectiveCampaignEntity> effectiveCampaigns,
  ) async {
    if (_exporting) return;
    setState(() => _exporting = true);

    final messenger = ScaffoldMessenger.of(context);
    try {
      await MarketingReportExporter(
        campaignUsecases: sl<CampaignUsecases>(),
      ).export(
        dashboard: dashboard,
        effectiveCampaigns: effectiveCampaigns,
      );
    } catch (e, st) {
      debugPrint('MARKETING EXPORT FAILED: $e\n$st');
      messenger.showSnackBar(
        SnackBar(content: Text('Could not export the report: $e')),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.pageBackground,
      drawer: const AppDrawer(selectedItem: 'Marketing'),
      appBar: AppBar(
        backgroundColor: AppPallete.cardBackground,
        surfaceTintColor: AppPallete.cardBackground,
        elevation: 0,
        title: const Text(
          'Marketing Overview',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsInitial || state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalyticsFailure) {
            return _ErrorView(message: state.message, onRetry: _refresh);
          }

          if (state is MarketingDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: _OverviewContent(
                dashboard: state.dashboard,
                onManageCampaigns: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CampaignScreen()),
                  );
                },
                onExport: () => _export(state.dashboard, state.effectiveCampaigns),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  final MarketingDashboardEntity dashboard;
  final VoidCallback onManageCampaigns;
  final VoidCallback onExport;

  const _OverviewContent({
    required this.dashboard,
    required this.onManageCampaigns,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final intro = const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marketing Overview',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 5),
                Text(
                  'Executive performance analytics and real-time financial ROI metrics.',
                  style: TextStyle(color: AppPallete.textSecondary, height: 1.35),
                ),
              ],
            );
            final actions = Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: onManageCampaigns,
                  icon: const Icon(Icons.campaign_outlined, size: 18),
                  label: const Text('Manage Campaigns'),
                ),
                OutlinedButton.icon(
                  onPressed: onExport,
                  icon: const Icon(Icons.download_outlined, size: 18),
                  label: const Text('Export'),
                ),
              ],
            );

            if (constraints.maxWidth < 650) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  intro,
                  const SizedBox(height: 14),
                  actions,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: intro),
                const SizedBox(width: 12),
                actions,
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final count = constraints.maxWidth >= 900 ? 4 : constraints.maxWidth >= 600 ? 2 : 1;
            final width = (constraints.maxWidth - (count - 1) * 12) / count;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricCard(
                  width: width,
                  label: 'TOTAL CAMPAIGNS',
                  value: '${dashboard.totalCampaigns}',
                  helper: 'All campaigns',
                  icon: Icons.layers_outlined,
                ),
                _MetricCard(
                  width: width,
                  label: 'ACTIVE',
                  value: '${dashboard.activeCampaigns}',
                  helper: 'Running campaigns',
                  icon: Icons.campaign_outlined,
                  iconColor: AppPallete.salesOrange,
                ),
                _MetricCard(
                  width: width,
                  label: 'OVERALL CPL',
                  value: '\$${dashboard.overallCpl.toStringAsFixed(2)}',
                  helper: 'Spent + connections',
                  icon: Icons.gps_fixed_rounded,
                  iconColor: Colors.cyan,
                  valueColor: Colors.cyan.shade800,
                ),
                _MetricCard(
                  width: width,
                  label: 'EXPECTED CONTENT',
                  value: '${dashboard.expectedContent}',
                  helper: 'Sum across campaigns',
                  icon: Icons.description_outlined,
                  iconColor: AppPallete.salesPurple,
                  valueColor: AppPallete.salesPurple,
                  accentBorder: true,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1000) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _SpentRevenueCard(dashboard: dashboard)),
                  const SizedBox(width: 14),
                  Expanded(child: _ConnectionsCard(dashboard: dashboard)),
                  const SizedBox(width: 14),
                  Expanded(child: _KpiCard(dashboard: dashboard)),
                ],
              );
            }

            return Column(
              children: [
                _SpentRevenueCard(dashboard: dashboard),
                const SizedBox(height: 14),
                _ConnectionsCard(dashboard: dashboard),
                const SizedBox(height: 14),
                _KpiCard(dashboard: dashboard),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final double width;
  final String label;
  final String value;
  final String helper;
  final IconData icon;
  final Color? iconColor;
  final Color? valueColor;
  final bool accentBorder;

  const _MetricCard({
    required this.width,
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
    this.iconColor,
    this.valueColor,
    this.accentBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentBorder ? const Color(0xFFE8D5FF) : AppPallete.cardBorder,
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x10000000), blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF58708F),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppPallete.salesPrimary).withOpacity(.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: iconColor ?? AppPallete.salesPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(helper, style: const TextStyle(color: AppPallete.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _Panel({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPallete.cardBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppPallete.textSecondary, fontSize: 12)),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _SpentRevenueCard extends StatelessWidget {
  final MarketingDashboardEntity dashboard;

  const _SpentRevenueCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final maxValue = math.max(1.0, math.max(dashboard.totalSpent, dashboard.totalRevenue)).toDouble();
    return _Panel(
      title: 'Spent vs Revenue',
      subtitle: 'Total marketing spend compared to revenue from won deals',
      child: SizedBox(
        height: 230,
        child: CustomPaint(
          painter: _BarChartPainter(
            spent: dashboard.totalSpent,
            revenue: dashboard.totalRevenue,
            maxValue: maxValue,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ConnectionsCard extends StatelessWidget {
  final MarketingDashboardEntity dashboard;

  const _ConnectionsCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final total = dashboard.totalConnections;
    final won = math.min(dashboard.wonDeals, total);
    final percentage = total == 0 ? 0.0 : won / total;

    return _Panel(
      title: 'Connections vs Won Deals',
      subtitle: 'Share of total connections that converted into won deals',
      child: Column(
        children: [
          SizedBox(
            height: 170,
            width: 170,
            child: CustomPaint(
              painter: _DonutPainter(percentage: percentage),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$won', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                    Text('of $total won', style: const TextStyle(color: AppPallete.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              _LegendDot(color: AppPallete.salesGreen, text: 'Won ($won)'),
              _LegendDot(color: const Color(0xFFD0D9E5), text: 'Other (${math.max(0, total - won)})'),
              Text(
                '${(percentage * 100).round()}%',
                style: const TextStyle(color: AppPallete.salesPurple, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final MarketingDashboardEntity dashboard;

  const _KpiCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Key Performance Indicators',
      subtitle: 'Overall win rate and return on investment',
      child: Row(
        children: [
          Expanded(
            child: _KpiRing(
              value: dashboard.winRate,
              label: 'Win Rate',
              color: AppPallete.salesPurple,
            ),
          ),
          Expanded(
            child: _KpiRing(
              value: dashboard.roi,
              label: 'ROI',
              color: AppPallete.salesGreen,
              showMoneyLabel: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiRing extends StatelessWidget {
  final double value;
  final String label;
  final Color color;
  final bool showMoneyLabel;

  const _KpiRing({
    required this.value,
    required this.label,
    required this.color,
    this.showMoneyLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = value.clamp(0, 100).toDouble();
    return Column(
      children: [
        SizedBox(
          width: 118,
          height: 118,
          child: CustomPaint(
            painter: _RingPainter(value: normalized / 100, color: color),
            child: Center(
              child: Text(
                '${normalized.round()}%',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppPallete.textSecondary, fontSize: 12)),
        if (showMoneyLabel) ...[
          const SizedBox(height: 6),
          Text(
            value >= 0 ? 'Making Money' : 'Losing Money',
            style: TextStyle(
              color: value >= 0 ? AppPallete.salesGreen : Colors.redAccent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendDot({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 11, color: AppPallete.textSecondary)),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final double spent;
  final double revenue;
  final double maxValue;

  const _BarChartPainter({
    required this.spent,
    required this.revenue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1;
    final chart = Rect.fromLTWH(40, 10, size.width - 55, size.height - 45);

    for (var i = 0; i <= 4; i++) {
      final y = chart.bottom - chart.height * i / 4;
      paint.color = const Color(0xFFE8EDF3);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), paint);
    }

    paint.color = const Color(0xFF78889A);
    canvas.drawLine(chart.bottomLeft, Offset(chart.left, chart.top), paint);
    canvas.drawLine(chart.bottomLeft, Offset(chart.right, chart.bottom), paint);

    final values = [spent, revenue];
    final labels = ['Total Spent', 'Total Revenue'];
    final barPaint = Paint()..color = AppPallete.salesGreen;
    final slot = chart.width / values.length;

    for (var i = 0; i < values.length; i++) {
      final h = chart.height * (values[i] / maxValue);
      final left = chart.left + slot * i + slot * .28;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, chart.bottom - h, slot * .44, h),
        const Radius.circular(8),
      );
      canvas.drawRRect(rect, barPaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(color: Color(0xFF314154), fontSize: 11, fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: slot);
      textPainter.paint(
        canvas,
        Offset(chart.left + slot * i + (slot - textPainter.width) / 2, chart.bottom + 12),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.spent != spent || oldDelegate.revenue != revenue;
}

class _DonutPainter extends CustomPainter {
  final double percentage;

  const _DonutPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..color = const Color(0xFFE9EEF4);
    final foreground = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.butt
      ..color = AppPallete.salesGreen;

    canvas.drawCircle(center, radius, background);
    if (percentage > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * percentage,
        false,
        foreground,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.percentage != percentage;
}

class _RingPainter extends CustomPainter {
  final double value;
  final Color color;

  const _RingPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = const Color(0xFFE9EEF4);
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawCircle(center, radius, bg);
    if (value > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * value,
        false,
        fg,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 44, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
