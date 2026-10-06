import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/campaign/campaign_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class CampaignUsecases {
  final CampaignRepository repo;

  CampaignUsecases({required this.repo});

  Future<Either<WhateverFailure, List<CampaignEntity>>> getCampaigns() {
    return repo.getCampaigns();
  }

  Future<Either<WhateverFailure, CampaignEntity>> createCampaign(
    CampaignEntity campaign,
  ) {
    return repo.createCampaign(campaign);
  }

  Future<Either<WhateverFailure, CampaignEntity>> updateCampaign({
    required String id,
    required CampaignEntity campaign,
  }) {
    return repo.updateCampaign(id: id, campaign: campaign);
  }

  Future<Either<WhateverFailure, void>> deleteCampaign(String id) {
    return repo.deleteCampaign(id);
  }
}
