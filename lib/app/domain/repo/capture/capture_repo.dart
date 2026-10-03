import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/capture_settings_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class CaptureRepository {
  Future<Either<WhateverFailure, CaptureSettingsEntity>> getCaptureSettings(
    String campaignId,
  );

  Future<Either<WhateverFailure, CaptureSettingsEntity>> setCaptureEnabled({
    required String campaignId,
    required bool enabled,
  });

  Future<Either<WhateverFailure, CaptureSettingsEntity>> regenerateToken(
    String campaignId,
  );
}
