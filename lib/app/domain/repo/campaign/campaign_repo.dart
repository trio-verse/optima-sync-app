import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class CampaignRepository {
  Future<Either<WhateverFailure, List<CampaignEntity>>> getCampaigns();

  Future<Either<WhateverFailure, CampaignEntity>> createCampaign(
    CampaignEntity campaign,
  );

  Future<Either<WhateverFailure, CampaignEntity>> updateCampaign({
    required String id,
    required CampaignEntity campaign,
  });

  Future<Either<WhateverFailure, void>> deleteCampaign(String id);
}
