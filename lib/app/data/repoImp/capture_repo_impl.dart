import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/capture_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/capture_settings_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/capture/capture_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class CaptureRepositoryImpl implements CaptureRepository {
  final CaptureRemoteDataSource remoteDataSource;

  CaptureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<WhateverFailure, CaptureSettingsEntity>> getCaptureSettings(
    String campaignId,
  ) async {
    try {
      final res = await remoteDataSource.getCaptureSettings(campaignId);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, CaptureSettingsEntity>> setCaptureEnabled({
    required String campaignId,
    required bool enabled,
  }) async {
    try {
      final res = await remoteDataSource.setCaptureEnabled(
        campaignId: campaignId,
        enabled: enabled,
      );
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }

  @override
  Future<Either<WhateverFailure, CaptureSettingsEntity>> regenerateToken(
    String campaignId,
  ) async {
    try {
      final res = await remoteDataSource.regenerateToken(campaignId);
      return Right(res);
    } catch (e) {
      return Left(WhateverFailure.whatoffline());
    }
  }
}
