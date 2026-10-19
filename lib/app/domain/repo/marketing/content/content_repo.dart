import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';

abstract class ContentRepository {
  Future<Either<WhateverFailure, List<ContentEntity>>> getCampaignContents(CampaignEntity campaign);

  Future<Either<WhateverFailure, ContentEntity>> createContent(ContentEntity content);
  Future<Either<WhateverFailure, ContentEntity>> updateContent(ContentEntity content);
  Future<Either<WhateverFailure, void>> deleteContent(ContentEntity content);
}
