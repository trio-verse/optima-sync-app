import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/content/content_repo.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

class ContentUsecases {
  final ContentRepository repo;

  ContentUsecases({required this.repo});

  Future<Either<ContentError, List<ContentEntity>>> getCampaignContents(String campaignId) {
    return repo.getCampaignContents(campaignId);
  }

  Future<Either<ContentError, ContentEntity>> createContent(ContentEntity content) {
    return repo.createContent(content);
  }

  Future<Either<ContentError, ContentEntity>> updateContent(ContentEntity content) {
    return repo.updateContent(content);
  }

  Future<Either<ContentError, void>> deleteContent(ContentEntity content) {
    return repo.deleteContent(content);
  }
}
