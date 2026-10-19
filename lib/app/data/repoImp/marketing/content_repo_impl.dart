import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/marketing/content_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/content/content_repo.dart';
import 'package:optima_sync_v2/core/errors/exceptions/exceptions.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remoteDataSource;

  ContentRepositoryImpl({required this.remoteDataSource});

  Future<Either<MarketingError, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on OfflineException {
      return const Left(MarketingError.offline());
    } on UnauthorizedException {
      return const Left(MarketingError.sessionExpired());
    } on NoOrganizationException {
      return const Left(MarketingError.noOrganization());
    } on BadRequestException {
      return const Left(MarketingError.invalidData());
    } on NotFoundException {
      return const Left(MarketingError.notFound());
    } catch (e) {
      return const Left(MarketingError.serverError());
    }
  }

  @override
  Future<Either<MarketingError, List<ContentEntity>>> getCampaignContents(
    CampaignEntity campaign,
  ) => _guard(() => remoteDataSource.getCampaignContents(campaign));

  @override
  Future<Either<MarketingError, ContentEntity>> getContent(
    ContentEntity content,
  ) => _guard(() => remoteDataSource.getContent(content));

  @override
  Future<Either<MarketingError, ContentEntity>> createContent(
    ContentEntity content,
  ) => _guard(() => remoteDataSource.createContent(content));

  @override
  Future<Either<MarketingError, ContentEntity>> updateContent(
    ContentEntity content,
  ) => _guard(() => remoteDataSource.updateContent(content));

  @override
  Future<Either<MarketingError, void>> deleteContent(ContentEntity content) =>
      _guard<void>(() => remoteDataSource.deleteContent(content));
}
