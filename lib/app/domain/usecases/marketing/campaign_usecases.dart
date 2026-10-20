import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/campaign/campaign_repo.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

class CampaignUsecases {
  final CampaignRepository repo;

  CampaignUsecases({required this.repo});

  Future<Either<MarketingError, List<CampaignEntity>>> getCampaigns() {
    return repo.getCampaigns();
  }

  Future<Either<MarketingError, CampaignEntity>> createCampaign(CampaignEntity campaign) {
    return repo.createCampaign(campaign);
  }

  Future<Either<MarketingError, CampaignEntity>> updateCampaign(CampaignEntity campaign) {
    return repo.updateCampaign(campaign);
  }

  Future<Either<MarketingError, void>> deleteCampaign(CampaignEntity campaign) {
    return repo.deleteCampaign(campaign);
  }
}
