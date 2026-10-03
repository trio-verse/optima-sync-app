import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/capture_settings_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/capture/capture_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class CaptureUsecases {
  final CaptureRepository repo;

  CaptureUsecases({required this.repo});

  Future<Either<WhateverFailure, CaptureSettingsEntity>> getCaptureSettings(
    String campaignId,
  ) {
    return repo.getCaptureSettings(campaignId);
  }

  Future<Either<WhateverFailure, CaptureSettingsEntity>> setCaptureEnabled({
    required String campaignId,
    required bool enabled,
  }) {
    return repo.setCaptureEnabled(campaignId: campaignId, enabled: enabled);
  }

  Future<Either<WhateverFailure, CaptureSettingsEntity>> regenerateToken(
    String campaignId,
  ) {
    return repo.regenerateToken(campaignId);
  }
}
