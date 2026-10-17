dynamic _first(Map json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key) && json[key] != null) return json[key];
  }
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(
    value.toString().replaceAll('%', '').replaceAll('\$', '').trim(),
  );
}

int? _toInt(dynamic value) => _toDouble(value)?.round();

class MarketingDashboardEntity {
  final int totalCampaigns;
  final int activeCampaigns;
  final int expectedContent;
  final int totalConnections;
  final int wonDeals;

  final double totalSpent;
  final double totalRevenue;
  final double overallCpl;
  final double winRate;
  final double roi;

  final List<CampaignAnalyticsEntity> perCampaign;

  const MarketingDashboardEntity({
    required this.totalCampaigns,
    required this.activeCampaigns,
    required this.expectedContent,
    required this.totalConnections,
    required this.wonDeals,
    required this.totalSpent,
    required this.totalRevenue,
    required this.overallCpl,
    required this.winRate,
    required this.roi,
    required this.perCampaign,
  });

  factory MarketingDashboardEntity.fromJson(Map<String, dynamic> json) {
    final totalSpent =
        _toDouble(
          _first(json, [
            'total_spent',
            'spent',
            'marketing_spend',
            'totalSpend',
          ]),
        ) ??
        0;

    final totalRevenue =
        _toDouble(
          _first(json, [
            'total_revenue',
            'revenue',
            'won_revenue',
            'totalRevenue',
          ]),
        ) ??
        0;

    final totalConnections =
        _toInt(
          _first(json, [
            'total_cnnections',
            'total_connections',
            'connections',
            'connection_count',
            'totalConnections',
          ]),
        ) ??
        0;

    final wonDeals =
        _toInt(
          _first(json, [
            'total_wins',
            'won_deals',
            'won',
            'won_connections',
            'wonDeals',
          ]),
        ) ??
        0;

    final rawPerCampaign = json['per_campaign'];

    return MarketingDashboardEntity(
      totalCampaigns:
          _toInt(
            _first(json, [
              'total_campaigns',
              'campaigns_count',
              'totalCampaigns',
            ]),
          ) ??
          0,
      activeCampaigns:
          _toInt(
            _first(json, [
              'active_campaigns',
              'active_count',
              'activeCampaigns',
            ]),
          ) ??
          0,
      expectedContent:
          _toInt(
            _first(json, [
              'expected_content',
              'expectedContent',
              'total_expected_content',
              'estimated_content_count',
            ]),
          ) ??
          0,
      totalConnections: totalConnections,
      wonDeals: wonDeals,
      totalSpent: totalSpent,
      totalRevenue: totalRevenue,
      overallCpl:
          _toDouble(
            _first(json, [
              'overall_CPL',
              'overall_cpl',
              'overallCpl',
              'cpl',
              'cost_per_lead',
            ]),
          ) ??
          0,
      winRate:
          _toDouble(_first(json, ['win_rate', 'winRate'])) ??
          (totalConnections == 0 ? 0 : wonDeals / totalConnections * 100),
      roi:
          _toDouble(
            _first(json, [
              'overall_percentage_ROI',
              'roi',
              'ROI',
              'return_on_investment',
            ]),
          ) ??
          (totalSpent == 0
              ? 0
              : (totalRevenue - totalSpent) / totalSpent * 100),
      perCampaign: (rawPerCampaign is List ? rawPerCampaign : const [])
          .whereType<Map>()
          .map(
            (e) =>
                CampaignAnalyticsEntity.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_campaigns': totalCampaigns,
      'active_campaigns': activeCampaigns,
      'expected_content': expectedContent,
      'total_connections': totalConnections,
      'won_deals': wonDeals,
      'total_spent': totalSpent,
      'total_revenue': totalRevenue,
      'overall_cpl': overallCpl,
      'win_rate': winRate,
      'roi': roi,
      'per_campaign': perCampaign,
    };
  }
}

class EffectiveCampaignEntity {
  final String? id;
  final String name;

  const EffectiveCampaignEntity({this.id, required this.name});

  factory EffectiveCampaignEntity.fromJson(Map<String, dynamic> json) {
    return EffectiveCampaignEntity(
      id: (json['id'] ?? json['campaign_id'])?.toString(),
      name:
          (json['name'] ?? json['campaign_name'] ?? json['title'] ?? 'Campaign')
              .toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'name': name};
  }
}

class CampaignAnalyticsEntity {
  final String? id;
  final double? spent;
  final double? revenue;
  final double? cpl;
  final double? roi;
  final double? winRate;
  final int? connections;
  final int? wins;

  const CampaignAnalyticsEntity({
    this.id,
    this.spent,
    this.revenue,
    this.cpl,
    this.roi,
    this.winRate,
    this.connections,
    this.wins,
  });

  factory CampaignAnalyticsEntity.fromJson(Map<String, dynamic> json) {
    final scopes = <Map>[
      json,
      for (final k in const ['metrics', 'kpis', 'kpi', 'data'])
        if (json[k] is Map) json[k] as Map,
    ];

    dynamic find(List<String> keys) {
      for (final scope in scopes) {
        final value = _first(scope, keys);
        if (value != null) return value;
      }
      return null;
    }

    return CampaignAnalyticsEntity(
      id: find(['id', 'campaign_id'])?.toString(),
      spent: _toDouble(find(['spent', 'total_spent', 'spend'])),
      revenue: _toDouble(find(['revenue', 'total_revenue', 'won_revenue'])),
      cpl: _toDouble(find(['cpl', 'cost_per_lead', 'cost_per_connection'])),
      roi: _toDouble(find(['roi', 'return_on_investment'])),
      winRate: _toDouble(find(['win_rate', 'winRate'])),
      connections: _toInt(
        find(['connections', 'total_connections', 'connections_count']),
      ),
      wins: _toInt(
        find(['wins', 'won_deals', 'won', 'won_connections', 'won_count']),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (spent != null) 'spent': spent,
      if (revenue != null) 'revenue': revenue,
      if (cpl != null) 'cpl': cpl,
      if (roi != null) 'roi': roi,
      if (winRate != null) 'win_rate': winRate,
      if (connections != null) 'connections': connections,
      if (wins != null) 'wins': wins,
    };
  }
}
