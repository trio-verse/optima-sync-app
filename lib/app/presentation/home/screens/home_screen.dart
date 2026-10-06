import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/sales_dashboard_entity.dart';
import 'package:optima_sync_v2/app/presentation/connection/screen/all_connections_log_screen.dart';
import 'package:optima_sync_v2/app/presentation/home/bloc/home_bloc.dart';
import 'package:optima_sync_v2/app/presentation/home/bloc/home_event.dart';
import 'package:optima_sync_v2/app/presentation/home/bloc/home_state.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';
import 'package:optima_sync_v2/core/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeDashboard());
  }

  Future<void> _openSales() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AllConnectionsLogScreen()),
    );

    if (!mounted) return;
    context.read<HomeBloc>().add(const LoadHomeDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.pageBackground,
      appBar: AppBar(
        backgroundColor: AppPallete.cardBackground,
        surfaceTintColor: AppPallete.cardBackground,
        elevation: 0,

        iconTheme: const IconThemeData(color: AppPallete.textPrimary),
      ),
      drawer: const AppDrawer(selectedItem: 'Home'),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeFailure) {
            return _DashboardError(
              message: state.message,
              onRetry: () =>
                  context.read<HomeBloc>().add(const LoadHomeDashboard()),
            );
          }

          final dashboard = (state as HomeSuccess).dashboard;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const LoadHomeDashboard());
              await context.read<HomeBloc>().stream.firstWhere(
                (next) => next is HomeSuccess || next is HomeFailure,
              );
            },
            child: _DashboardContent(
              dashboard: dashboard,
              onViewAllConnections: _openSales,
            ),
          );
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final SalesDashboardEntity dashboard;
  final VoidCallback onViewAllConnections;

  const _DashboardContent({
    required this.dashboard,
    required this.onViewAllConnections,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      children: [
        _DashboardIntro(onViewAllConnections: onViewAllConnections),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 620) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _WinRateCard(dashboard: dashboard)),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: _MetricGrid(dashboard: dashboard)),
                ],
              );
            }

            return Column(
              children: [
                _WinRateCard(dashboard: dashboard),
                const SizedBox(height: 12),
                _MetricGrid(dashboard: dashboard),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final stageCard = _StageBreakdownCard(dashboard: dashboard);
            final productsCard = _TopProductsCard(dashboard: dashboard);

            if (constraints.maxWidth >= 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: stageCard),
                  const SizedBox(width: 12),
                  Expanded(child: productsCard),
                ],
              );
            }

            return Column(
              children: [stageCard, const SizedBox(height: 12), productsCard],
            );
          },
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final cityCard = _BreakdownCard(
              eyebrow: 'COVERAGE',
              title: 'Clients by city',
              icon: Icons.location_on_outlined,
              accent: AppPallete.salesGreen,
              total: dashboard.totalClients,
              items: dashboard.clientsByCity,
            );
            final industryCard = _BreakdownCard(
              eyebrow: 'SEGMENTS',
              title: 'Clients by industry',
              icon: Icons.business_center_outlined,
              accent: AppPallete.salesPurple,
              total: dashboard.totalClients,
              items: dashboard.clientsByIndustry,
            );

            if (constraints.maxWidth >= 620) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cityCard),
                  const SizedBox(width: 12),
                  Expanded(child: industryCard),
                ],
              );
            }

            return Column(
              children: [cityCard, const SizedBox(height: 12), industryCard],
            );
          },
        ),
        const SizedBox(height: 12),
        _RecentConnectionsCard(
          connections: dashboard.recentConnections,
          onViewAll: onViewAllConnections,
        ),
      ],
    );
  }
}

class _DashboardIntro extends StatelessWidget {
  final VoidCallback onViewAllConnections;

  const _DashboardIntro({required this.onViewAllConnections});

  @override
  Widget build(BuildContext context) {
    final copy = const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Here's how the pipeline looks",
          style: TextStyle(
            fontSize: 22,
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: AppPallete.textPrimary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Clients, connections and product performance, all in one place.',
          style: TextStyle(color: AppPallete.textSecondary, fontSize: 12.5),
        ),
      ],
    );

    final action = FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: AppPallete.salesPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onViewAllConnections,
      icon: const Icon(Icons.link_rounded, size: 18),
      label: const Text('View All Connections'),
    );

    return _CardShell(
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 560) {
            return Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: 18),
                action,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy,
              const SizedBox(height: 16),
              Align(alignment: Alignment.centerRight, child: action),
            ],
          );
        },
      ),
    );
  }
}

class _WinRateCard extends StatelessWidget {
  final SalesDashboardEntity dashboard;

  const _WinRateCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final progress = (dashboard.winRate / 100).clamp(0.0, 1.0).toDouble();
    final percent = dashboard.winRate.round();

    return _CardShell(
      child: Row(
        children: [
          SizedBox(
            width: 106,
            height: 106,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 98,
                  height: 98,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: AppPallete.placeholderBg,
                    color: AppPallete.salesPrimary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppPallete.textPrimary,
                      ),
                    ),
                    const Text(
                      'WIN RATE',
                      style: TextStyle(
                        fontSize: 8,
                        letterSpacing: .8,
                        color: AppPallete.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dashboard.wonConnections} / ${dashboard.totalConnections}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'connections closed as Won',
                  style: TextStyle(
                    color: AppPallete.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$ ${_money(dashboard.wonRevenue)} in won revenue',
                  style: const TextStyle(
                    color: AppPallete.salesGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final SalesDashboardEntity dashboard;

  const _MetricGrid({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _MetricData(
        icon: Icons.groups_2_outlined,
        value: dashboard.totalClients.toString(),
        label: 'Total Clients',
        accent: AppPallete.salesPrimary,
      ),
      _MetricData(
        icon: Icons.link_rounded,
        value: dashboard.totalConnections.toString(),
        label: 'Total Connections',
        accent: AppPallete.salesPurple,
      ),
      _MetricData(
        icon: Icons.inventory_2_outlined,
        value: dashboard.totalProducts.toString(),
        label: 'Total Products',
        accent: AppPallete.salesPurple,
      ),
      _MetricData(
        icon: Icons.location_on_outlined,
        value: dashboard.citiesCovered.toString(),
        label: 'Cities Covered',
        accent: AppPallete.salesGreen,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = width >= 350 ? (width - 10) / 2 : width;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final card in cards)
              SizedBox(
                width: itemWidth,
                child: _MetricCard(data: card),
              ),
          ],
        );
      },
    );
  }
}

class _MetricData {
  final IconData icon;
  final String value;
  final String label;
  final Color accent;

  const _MetricData({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
  });
}

class _MetricCard extends StatelessWidget {
  final _MetricData data;

  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.accent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.accent, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppPallete.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageBreakdownCard extends StatelessWidget {
  final SalesDashboardEntity dashboard;

  const _StageBreakdownCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'PIPELINE',
            title: 'Connections by stage',
            icon: Icons.trending_up_rounded,
          ),
          const SizedBox(height: 14),
          for (final stage in ConnectionStage.values) ...[
            _ProgressRow(
              label: ConnectionStage.label(stage),
              count: dashboard.stageCounts[stage] ?? 0,
              total: dashboard.totalConnections,
              color: stage == ConnectionStage.won
                  ? AppPallete.salesGreen
                  : ConnectionStage.color(stage),
            ),
            if (stage != ConnectionStage.values.last)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _TopProductsCard extends StatelessWidget {
  final SalesDashboardEntity dashboard;

  const _TopProductsCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final maxDeals = dashboard.topProducts.isEmpty
        ? 1
        : dashboard.topProducts.first.deals;

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'DEMAND',
            title: 'Top products',
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: 14),
          if (dashboard.topProducts.isEmpty)
            const _SmallEmpty(text: 'No product activity yet')
          else
            for (var i = 0; i < dashboard.topProducts.length; i++) ...[
              _ProductRow(
                index: i + 1,
                product: dashboard.topProducts[i],
                maxDeals: maxDeals,
              ),
              if (i != dashboard.topProducts.length - 1)
                const SizedBox(height: 14),
            ],
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final int index;
  final DashboardTopProduct product;
  final int maxDeals;

  const _ProductRow({
    required this.index,
    required this.product,
    required this.maxDeals,
  });

  @override
  Widget build(BuildContext context) {
    final value = maxDeals == 0 ? 0.0 : product.deals / maxDeals;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppPallete.salesOrange,
          foregroundColor: Colors.white,
          child: Text(
            '$index',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${product.name}  \$${_money(product.price)}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${product.deals} deals · ${product.clients} clients',
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: AppPallete.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  value: value,
                  backgroundColor: AppPallete.placeholderBg,
                  color: AppPallete.salesPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final String eyebrow;
  final String title;
  final IconData icon;
  final Color accent;
  final int total;
  final List<DashboardBreakdownItem> items;

  const _BreakdownCard({
    required this.eyebrow,
    required this.title,
    required this.icon,
    required this.accent,
    required this.total,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(eyebrow: eyebrow, title: title, icon: icon),
          const SizedBox(height: 14),
          if (items.isEmpty)
            const _SmallEmpty(text: 'No client data yet')
          else
            for (var i = 0; i < items.take(5).length; i++) ...[
              Builder(
                builder: (context) {
                  final item = items[i];
                  return _ProgressRow(
                    label: item.label,
                    count: item.count,
                    total: total,
                    color: accent,
                  );
                },
              ),
              if (i != items.take(5).length - 1) const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _RecentConnectionsCard extends StatelessWidget {
  final List<ConnectionEntity> connections;
  final VoidCallback onViewAll;

  const _RecentConnectionsCard({
    required this.connections,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _SectionHeader(
                  eyebrow: 'LATEST ACTIVITY',
                  title: 'Recent connections',
                  icon: Icons.schedule_rounded,
                ),
              ),
              TextButton(onPressed: onViewAll, child: const Text('View all')),
            ],
          ),
          const SizedBox(height: 8),
          if (connections.isEmpty)
            const _SmallEmpty(text: 'No recent connections')
          else
            for (var i = 0; i < connections.length; i++) ...[
              _RecentConnectionRow(connection: connections[i]),
              if (i != connections.length - 1)
                const Divider(height: 18, color: AppPallete.cardBorder),
            ],
        ],
      ),
    );
  }
}

class _RecentConnectionRow extends StatelessWidget {
  final ConnectionEntity connection;

  const _RecentConnectionRow({required this.connection});

  @override
  Widget build(BuildContext context) {
    final name = connection.clientName?.trim().isNotEmpty == true
        ? connection.clientName!.trim()
        : 'Client';
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();
    final stageColor = ConnectionStage.color(connection.stage);

    return Row(
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: AppPallete.salesGreen.withOpacity(0.12),
          foregroundColor: AppPallete.salesGreen,
          child: Text(
            initial,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: stageColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ConnectionStage.label(connection.stage),
                      style: TextStyle(
                        color: stageColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                connection.productName ?? 'Product',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppPallete.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _dateLabel(connection.createdAt),
          style: const TextStyle(
            fontSize: 9.5,
            color: AppPallete.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0
        ? 0.0
        : (count / total).clamp(0.0, 1.0).toDouble();
    final percent = total == 0 ? 0 : ((count / total) * 100).round();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$count · $percent%',
              style: const TextStyle(
                fontSize: 9.5,
                color: AppPallete.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            minHeight: 6,
            value: progress,
            backgroundColor: AppPallete.placeholderBg,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final IconData icon;

  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppPallete.salesPrimarySoft,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: AppPallete.salesPrimary, size: 17),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: AppPallete.salesPrimary,
                  fontSize: 8,
                  letterSpacing: .9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _CardShell({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SmallEmpty extends StatelessWidget {
  final String text;

  const _SmallEmpty({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: AppPallete.textSecondary, fontSize: 12),
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: AppPallete.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppPallete.salesPrimary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

String _money(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}

String _dateLabel(DateTime? date) {
  if (date == null) return '';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final local = date.toLocal();
  return '${months[local.month - 1]} ${local.day}, ${local.year}';
}
