const List<String> kCampaignStatuses = [
  'active',
  'draft',
  'paused',
  'completed',
  'cancelled',
];

class CampaignEntity {
  final String? id;
  final String name;
  final String description;
  final String? startDate;
  final String? endDate;
  final double? expectedBudget;
  final int? estimatedContentCount;
  final String status;
  final String target;

  final double? spent;
  final int? connections;
  final double? cpl;
  final double? roi;

  final String? updatedAt;
  final int? wins;
  final double? winRate;
  final double? revenue;

  const CampaignEntity({
    this.id,
    required this.name,
    required this.description,
    this.startDate,
    this.endDate,
    this.expectedBudget,
    this.estimatedContentCount,
    this.status = 'draft',
    required this.target,
    this.spent,
    this.connections,
    this.cpl,
    this.roi,
    this.updatedAt,
    this.wins,
    this.winRate,
    this.revenue,
  });

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(
      value.toString().replaceAll('%', '').replaceAll('\$', '').trim(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  static dynamic _first(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key) && json[key] != null) return json[key];
    }
    return null;
  }

  factory CampaignEntity.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] is Map
        ? Map<String, dynamic>.from(json['metrics'] as Map)
        : <String, dynamic>{};
    final data = <String, dynamic>{...json, ...metrics};

    return CampaignEntity(
      id: data['id']?.toString(),
      name: data['name']?.toString() ?? data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      startDate: _asString(data['start_date']),
      endDate: _asString(data['end_date']),
      expectedBudget: _toDouble(data['expected_budget'] ?? data['budget']),
      estimatedContentCount: _toInt(
        data['estimated_content_count'] ?? data['content_count'],
      ),
      status: _asString(data['status']) ?? 'draft',
      target:
          data['target']?.toString() ??
          data['target_audience']?.toString() ??
          '',
      spent: _toDouble(_first(data, ['spent', 'total_spent', 'spend'])),
      connections: _toInt(_first(data, ['connections', 'total_connections'])),
      cpl: _toDouble(
        _first(data, ['cpl', 'cost_per_lead', 'cost_per_connection']),
      ),
      roi: _toDouble(_first(data, ['roi', 'return_on_investment'])),
      updatedAt: _asString(data['updated_at'] ?? data['updatedAt']),
      wins: _toInt(_first(data, ['wins', 'won_deals', 'won', 'won_count'])),
      winRate: _toDouble(_first(data, ['win_rate', 'winRate'])),
      revenue: _toDouble(
        _first(data, ['revenue', 'total_revenue', 'won_revenue']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      if (startDate != null && startDate!.isNotEmpty) "start_date": startDate,
      if (endDate != null && endDate!.isNotEmpty) "end_date": endDate,
      if (expectedBudget != null) "expected_budget": expectedBudget,
      if (estimatedContentCount != null)
        "estimated_content_count": estimatedContentCount,
      "status": status,
      "target": target,
    };
  }

  CampaignEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? startDate,
    String? endDate,
    double? expectedBudget,
    int? estimatedContentCount,
    String? status,
    String? target,
    double? spent,
    int? connections,
    double? cpl,
    double? roi,
    String? updatedAt,
    int? wins,
    double? winRate,
    double? revenue,
  }) {
    return CampaignEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      expectedBudget: expectedBudget ?? this.expectedBudget,
      estimatedContentCount:
          estimatedContentCount ?? this.estimatedContentCount,
      status: status ?? this.status,
      target: target ?? this.target,
      spent: spent ?? this.spent,
      connections: connections ?? this.connections,
      cpl: cpl ?? this.cpl,
      roi: roi ?? this.roi,
      updatedAt: updatedAt ?? this.updatedAt,
      wins: wins ?? this.wins,
      winRate: winRate ?? this.winRate,
      revenue: revenue ?? this.revenue,
    );
  }
}
