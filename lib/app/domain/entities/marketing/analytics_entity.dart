class MarketingDashboardEntity {
  final int totalCampaigns;
  final int activeCampaigns;
  final int totalConnections;
  final int wonDeals; // total_wins

  final double totalSpent;
  final double totalRevenue;
  final double overallCpl;
  final double roi;

  final List<CampaignAnalyticsEntity> perCampaign;

  const MarketingDashboardEntity({
    required this.totalCampaigns,
    required this.activeCampaigns,
    required this.totalConnections,
    required this.wonDeals,
    required this.totalSpent,
    required this.totalRevenue,
    required this.overallCpl,
    required this.roi,
    required this.perCampaign,
  });

  factory MarketingDashboardEntity.fromJson(Map<String, dynamic> json) {
    return MarketingDashboardEntity(
      totalCampaigns: json['totalCampaigns'],
      activeCampaigns: json['activeCampaigns'],
      totalConnections: json['total_connections'],
      wonDeals: json["won_deals"],
      totalSpent: (json['total_spent'] as num).toDouble(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      overallCpl: json['overall_CPL'].toDouble(),
      roi:
          json['overall_percentage_ROI'].toDouble() ??
          ((json['total_spent'] as num).toDouble() == 0
              ? 0
              : ((json['total_revenue'] as num).toDouble() - (json['total_spent'] as num).toDouble()) /
                    (json['total_spent'] as num).toDouble() *
                    100),
      perCampaign: (json['per_campaign'] as List)
          .map((e) => CampaignAnalyticsEntity.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_campaigns': totalCampaigns,
      'active_campaigns': activeCampaigns,
      'total_cnnections': totalConnections,
      'total_wins': wonDeals,
      'total_spent': totalSpent,
      'total_revenue': totalRevenue,
      'overall_cpl': overallCpl,
      'overall_percentage_ROI': roi,
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
      name: (json['name'] ?? json['campaign_name'] ?? json['title'] ?? 'Campaign').toString(),
    );
  }
}

class CampaignAnalyticsEntity {
  final String id;
  final String name;
  final double? cpl;
  final double? roi;
  final double winRate;

  const CampaignAnalyticsEntity({required this.id, required this.name, this.cpl, this.roi, required this.winRate});

  factory CampaignAnalyticsEntity.fromJson(Map<String, dynamic> json) {
    return CampaignAnalyticsEntity(
      id: json['id'].toString(),
      name: json['name'].toString(),
      cpl: (json['cpl'] as num?)?.toDouble(),
      roi: (json['roi'] as num?)?.toDouble(),
      winRate: (json['win_rate'] as num).toDouble(),
    );
  }
}
