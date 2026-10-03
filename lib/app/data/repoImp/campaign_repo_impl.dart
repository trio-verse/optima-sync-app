import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/campaign_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/campaign/campaign_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignRemoteDataSource remoteDataSource;

  CampaignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, List<CampaignEntity>>> getCampaigns() async {
    try {
      final res = await remoteDataSource.getCampaigns();
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, CampaignEntity>> createCampaign(
    CampaignEntity campaign,
  ) async {
    try {
      final res = await remoteDataSource.createCampaign(campaign);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, CampaignEntity>> updateCampaign({
    required String id,
    required CampaignEntity campaign,
  }) async {
    try {
      final res = await remoteDataSource.updateCampaign(
        id: id,
        campaign: campaign,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, void>> deleteCampaign(String id) async {
    try {
      final res = await remoteDataSource.deleteCampaign(id);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
