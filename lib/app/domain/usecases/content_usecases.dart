import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/content/content_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class ContentUsecases {
  final ContentRepository repo;

  ContentUsecases({required this.repo});

  Future<Either<WhateverFailure, List<ContentEntity>>> getCampaignContents(
    String campaignId,
  ) {
    return repo.getCampaignContents(campaignId);
  }

  Future<Either<WhateverFailure, ContentEntity>> getContent({
    required String campaignId,
    required String id,
  }) {
    return repo.getContent(campaignId: campaignId, id: id);
  }

  Future<Either<WhateverFailure, ContentEntity>> createContent({
    required String campaignId,
    required ContentEntity content,
  }) {
    return repo.createContent(campaignId: campaignId, content: content);
  }

  Future<Either<WhateverFailure, ContentEntity>> updateContent({
    required String campaignId,
    required String id,
    required ContentEntity content,
  }) {
    return repo.updateContent(campaignId: campaignId, id: id, content: content);
  }

  Future<Either<WhateverFailure, void>> deleteContent({
    required String campaignId,
    required String id,
  }) {
    return repo.deleteContent(campaignId: campaignId, id: id);
  }
}
