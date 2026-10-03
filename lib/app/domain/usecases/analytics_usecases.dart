import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/analytics/analytics_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class AnalyticsUsecases {
  final AnalyticsRepository repo;

  AnalyticsUsecases({required this.repo});

  Future<Either<WhateverFailure, MarketingDashboardEntity>> getDashboard() {
    return repo.getDashboard();
  }

  Future<Either<WhateverFailure, List<EffectiveCampaignEntity>>>
      getEffectiveCampaigns() {
    return repo.getEffectiveCampaigns();
  }

  Future<Either<WhateverFailure, CampaignAnalyticsEntity>> getCampaignAnalytics(
    String campaignId,
  ) {
    return repo.getCampaignAnalytics(campaignId);
  }
}
