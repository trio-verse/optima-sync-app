import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/analytics_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/analytics/analytics_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, MarketingDashboardEntity>> getDashboard() async {
    try {
      final res = await remoteDataSource.getDashboard();
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, List<EffectiveCampaignEntity>>>
      getEffectiveCampaigns() async {
    try {
      final res = await remoteDataSource.getEffectiveCampaigns();
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, CampaignAnalyticsEntity>> getCampaignAnalytics(
    String campaignId,
  ) async {
    try {
      final res = await remoteDataSource.getCampaignAnalytics(campaignId);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
