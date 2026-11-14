import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/analytics/analytics_repo.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

class AnalyticsUsecases {
  final AnalyticsRepository repo;

  AnalyticsUsecases({required this.repo});

  Future<Either<AnalyticsError, MarketingDashboardEntity>> getDashboard() {
    return repo.getDashboard();
  }

  Future<Either<AnalyticsError, List<EffectiveCampaignEntity>>> getEffectiveCampaigns() {
    return repo.getEffectiveCampaigns();
  }

  Future<Either<AnalyticsError, CampaignAnalyticsEntity>> getCampaignAnalytics(String campaignId) {
    return repo.getCampaignAnalytics(campaignId);
  }
}
