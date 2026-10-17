import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/content/content_repo.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';

class ContentUsecases {
  final ContentRepository repo;

  ContentUsecases({required this.repo});

  Future<Either<WhateverFailure, List<ContentEntity>>> getCampaignContents(
    CampaignEntity campaign,
  ) {
    return repo.getCampaignContents(campaign);
  }

  Future<Either<WhateverFailure, ContentEntity>> getContent(
    ContentEntity content,
  ) {
    return repo.getContent(content);
  }

  Future<Either<WhateverFailure, ContentEntity>> createContent(
    ContentEntity content,
  ) {
    return repo.createContent(content);
  }

  Future<Either<WhateverFailure, ContentEntity>> updateContent(
    ContentEntity content,
  ) {
    return repo.updateContent(content);
  }

  Future<Either<WhateverFailure, void>> deleteContent(ContentEntity content) {
    return repo.deleteContent(content);
  }
}
