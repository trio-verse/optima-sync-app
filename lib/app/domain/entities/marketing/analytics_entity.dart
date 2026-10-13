class MarketingDashboardEntity {
  final Map<String, dynamic> raw;

  const MarketingDashboardEntity({required this.raw});

  factory MarketingDashboardEntity.fromJson(Map<String, dynamic> json) {
    return MarketingDashboardEntity(raw: json);
  }

  dynamic _first(List<String> keys) {
    for (final key in keys) {
      if (raw.containsKey(key) && raw[key] != null) return raw[key];
    }
    return null;
  }

  double _number(List<String> keys) {
    final value = _first(keys);
    if (value is num) return value.toDouble();
    return double.tryParse(
          value?.toString().replaceAll('%', '').replaceAll('\$', '') ?? '',
        ) ??
        0;
  }

  int get totalCampaigns =>
      _number(['total_campaigns', 'campaigns_count', 'totalCampaigns']).round();

  int get activeCampaigns =>
      _number(['active_campaigns', 'active_count', 'activeCampaigns']).round();

  double get overallCpl => _number([
    'overall_CPL',
    'overall_cpl',
    'overallCpl',
    'cpl',
    'cost_per_lead',
  ]);

  int get expectedContent => _number([
    'expected_content',
    'expectedContent',
    'total_expected_content',
    'estimated_content_count',
  ]).round();

  List<Map<String, dynamic>> get perCampaign {
    final value = raw['per_campaign'];
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  double get totalSpent =>
      _number(['total_spent', 'spent', 'marketing_spend', 'totalSpend']);

  double get totalRevenue =>
      _number(['total_revenue', 'revenue', 'won_revenue', 'totalRevenue']);

  int get totalConnections => _number([
    'total_cnnections',
    'total_connections',
    'connections',
    'connection_count',
    'totalConnections',
  ]).round();

  int get wonDeals => _number([
    'total_wins',
    'won_deals',
    'won',
    'won_connections',
    'wonDeals',
  ]).round();

  double get winRate {
    final direct = _first(['win_rate', 'winRate']);
    if (direct != null) {
      return double.tryParse(direct.toString().replaceAll('%', '')) ?? 0;
    }
    if (totalConnections == 0) return 0;
    return wonDeals / totalConnections * 100;
  }

  double get roi {
    final direct = _first([
      'overall_percentage_ROI',
      'roi',
      'ROI',
      'return_on_investment',
    ]);
    if (direct != null) {
      return double.tryParse(direct.toString().replaceAll('%', '')) ?? 0;
    }
    if (totalSpent == 0) return 0;
    return (totalRevenue - totalSpent) / totalSpent * 100;
  }
}

class EffectiveCampaignEntity {
  final Map<String, dynamic> raw;

  const EffectiveCampaignEntity({required this.raw});

  factory EffectiveCampaignEntity.fromJson(Map<String, dynamic> json) {
    return EffectiveCampaignEntity(raw: json);
  }

  String get name =>
      (raw['name'] ?? raw['campaign_name'] ?? raw['title'] ?? 'Campaign')
          .toString();

  String? get id => raw['id']?.toString() ?? raw['campaign_id']?.toString();
}

class CampaignAnalyticsEntity {
  final Map<String, dynamic> raw;

  const CampaignAnalyticsEntity({required this.raw});

  factory CampaignAnalyticsEntity.fromJson(Map<String, dynamic> json) {
    return CampaignAnalyticsEntity(raw: json);
  }

  dynamic _find(List<String> keys) {
    final scopes = <Map>[
      raw,
      for (final k in const ['metrics', 'kpis', 'kpi', 'data'])
        if (raw[k] is Map) raw[k] as Map,
    ];
    for (final scope in scopes) {
      for (final key in keys) {
        if (scope[key] != null) return scope[key];
      }
    }
    return null;
  }

  double? _num(List<String> keys) {
    final value = _find(keys);
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(
      value.toString().replaceAll('%', '').replaceAll('\$', '').trim(),
    );
  }

  double? get spent => _num(['spent', 'total_spent', 'spend']);
  double? get revenue => _num(['revenue', 'total_revenue', 'won_revenue']);
  double? get cpl => _num(['cpl', 'cost_per_lead', 'cost_per_connection']);
  double? get roi => _num(['roi', 'return_on_investment']);
  double? get winRate => _num(['win_rate', 'winRate']);
  int? get connections =>
      _num(['connections', 'total_connections', 'connections_count'])?.round();
  int? get wins => _num([
    'wins',
    'won_deals',
    'won',
    'won_connections',
    'won_count',
  ])?.round();
}
