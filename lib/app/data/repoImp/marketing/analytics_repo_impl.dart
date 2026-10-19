import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/marketing/analytics_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/analytics_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/marketing/analytics/analytics_repo.dart';
import 'package:optima_sync_v2/core/errors/exceptions/exceptions.dart';
import 'package:optima_sync_v2/core/errors/marketing/marketing_errors.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({required this.remoteDataSource});

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
  Future<Either<MarketingError, MarketingDashboardEntity>> getDashboard() =>
      _guard(() => remoteDataSource.getDashboard());

  @override
  Future<Either<MarketingError, List<EffectiveCampaignEntity>>>
  getEffectiveCampaigns() =>
      _guard(() => remoteDataSource.getEffectiveCampaigns());

  @override
  Future<Either<MarketingError, CampaignAnalyticsEntity>> getCampaignAnalytics(
    CampaignEntity campaign,
  ) => _guard(() => remoteDataSource.getCampaignAnalytics(campaign));
}
