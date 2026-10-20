import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

abstract class AnalyticsRepository {
  Future<Either<MarketingError, MarketingDashboardEntity>> getDashboard();

  Future<Either<MarketingError, List<EffectiveCampaignEntity>>> getEffectiveCampaigns();

  Future<Either<MarketingError, CampaignAnalyticsEntity>> getCampaignAnalytics(CampaignEntity campaign);
}
