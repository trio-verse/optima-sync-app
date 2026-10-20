import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

abstract class ContentRepository {
  Future<Either<MarketingError, List<ContentEntity>>> getCampaignContents(String campaign);

  Future<Either<MarketingError, ContentEntity>> createContent(ContentEntity content);
  Future<Either<MarketingError, ContentEntity>> updateContent(ContentEntity content);
  Future<Either<MarketingError, void>> deleteContent(ContentEntity content);
}
