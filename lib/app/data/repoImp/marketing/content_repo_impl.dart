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

  Future<Either<ContentError, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on OfflineException {
      return const Left(ContentError.offline());
    } on UnauthorizedException {
      return const Left(ContentError.sessionExpired());
    } on NoOrganizationException {
      return const Left(ContentError.noOrganization());
    } on BadRequestException {
      return const Left(ContentError.invalidData());
    } on NotFoundException {
      return const Left(ContentError.notFound());
    } catch (e) {
      return const Left(ContentError.serverError());
    }
  }

  @override
  Future<Either<ContentError, List<ContentEntity>>> getCampaignContents(String campaignId) =>
      _guard(() => remoteDataSource.getCampaignContents(campaignId));

  @override
  Future<Either<ContentError, ContentEntity>> createContent(ContentEntity content) =>
      _guard(() => remoteDataSource.createContent(content));

  @override
  Future<Either<ContentError, ContentEntity>> updateContent(ContentEntity content) =>
      _guard(() => remoteDataSource.updateContent(content));

  @override
  Future<Either<ContentError, void>> deleteContent(ContentEntity content) =>
      _guard<void>(() => remoteDataSource.deleteContent(content));
}
