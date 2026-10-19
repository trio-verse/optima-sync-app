import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/marketing/campaign_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/campaign/campaign_repo.dart';
import 'package:optima_sync_v2/core/errors/exceptions/exceptions.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignRemoteDataSource remoteDataSource;

  CampaignRepositoryImpl({required this.remoteDataSource});

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
  Future<Either<MarketingError, List<CampaignEntity>>> getCampaigns() =>
      _guard(() => remoteDataSource.getCampaigns());

  @override
  Future<Either<MarketingError, CampaignEntity>> createCampaign(
    CampaignEntity campaign,
  ) => _guard(() => remoteDataSource.createCampaign(campaign));

  @override
  Future<Either<MarketingError, CampaignEntity>> updateCampaign(
    CampaignEntity campaign,
  ) => _guard(() => remoteDataSource.updateCampaign(campaign));

  @override
  Future<Either<MarketingError, void>> deleteCampaign(
    CampaignEntity campaign,
  ) => _guard<void>(() => remoteDataSource.deleteCampaign(campaign));
}
