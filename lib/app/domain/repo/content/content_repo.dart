import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class ContentRepository {
  Future<Either<WhateverFailure, List<ContentEntity>>> getCampaignContents(
    String campaignId,
  );

  Future<Either<WhateverFailure, ContentEntity>> getContent({
    required String campaignId,
    required String id,
  });

  Future<Either<WhateverFailure, ContentEntity>> createContent({
    required String campaignId,
    required ContentEntity content,
  });

  Future<Either<WhateverFailure, ContentEntity>> updateContent({
    required String campaignId,
    required String id,
    required ContentEntity content,
  });

  Future<Either<WhateverFailure, void>> deleteContent({
    required String campaignId,
    required String id,
  });
}
