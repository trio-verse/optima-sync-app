import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/analytics_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class AnalyticsRepository {
  Future<Either<WhateverFailure, MarketingDashboardEntity>> getDashboard();

  Future<Either<WhateverFailure, List<EffectiveCampaignEntity>>>
      getEffectiveCampaigns();

  Future<Either<WhateverFailure, CampaignAnalyticsEntity>> getCampaignAnalytics(
    String campaignId,
  );
}
