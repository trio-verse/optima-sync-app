import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

abstract class CampaignRepository {
  Future<Either<MarketingError, List<CampaignEntity>>> getCampaigns();

  Future<Either<MarketingError, CampaignEntity>> createCampaign(CampaignEntity campaign);

  Future<Either<MarketingError, CampaignEntity>> updateCampaign(CampaignEntity campaign);
  Future<Either<MarketingError, void>> deleteCampaign(CampaignEntity campaign);
}
