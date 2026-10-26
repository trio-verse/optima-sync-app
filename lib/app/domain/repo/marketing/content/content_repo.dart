import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

abstract class ContentRepository {
  Future<Either<ContentError, List<ContentEntity>>> getCampaignContents(String campaign);

  Future<Either<ContentError, ContentEntity>> createContent(ContentEntity content);
  Future<Either<ContentError, ContentEntity>> updateContent(ContentEntity content);
  Future<Either<ContentError, void>> deleteContent(ContentEntity content);
}
