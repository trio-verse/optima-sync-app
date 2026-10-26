import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

abstract class CampaignRepository {
  Future<Either<CampaignError, List<CampaignEntity>>> getCampaigns();

  Future<Either<CampaignError, CampaignEntity>> createCampaign(CampaignEntity campaign);

  Future<Either<CampaignError, CampaignEntity>> updateCampaign(CampaignEntity campaign);
  Future<Either<CampaignError, void>> deleteCampaign(CampaignEntity campaign);
}
