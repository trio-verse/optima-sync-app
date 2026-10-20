import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/analytics/analytics_repo.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

class AnalyticsUsecases {
  final AnalyticsRepository repo;

  AnalyticsUsecases({required this.repo});

  Future<Either<MarketingError, MarketingDashboardEntity>> getDashboard() {
    return repo.getDashboard();
  }

  Future<Either<MarketingError, List<EffectiveCampaignEntity>>> getEffectiveCampaigns() {
    return repo.getEffectiveCampaigns();
  }

  Future<Either<MarketingError, CampaignAnalyticsEntity>> getCampaignAnalytics(CampaignEntity campaign) {
    return repo.getCampaignAnalytics(campaign);
  }
}
