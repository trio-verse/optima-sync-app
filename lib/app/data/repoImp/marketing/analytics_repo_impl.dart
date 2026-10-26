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

  Future<Either<AnalyticsError, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on OfflineException {
      return const Left(AnalyticsError.offline());
    } on UnauthorizedException {
      return const Left(AnalyticsError.sessionExpired());
    } on BadRequestException {
      return const Left(AnalyticsError.invalidData());
    } on NotFoundException {
      return const Left(AnalyticsError.notFound());
    } catch (e) {
      return const Left(AnalyticsError.serverError());
    }
  }

  @override
  Future<Either<AnalyticsError, MarketingDashboardEntity>> getDashboard() =>
      _guard(() => remoteDataSource.getDashboard());

  @override
  Future<Either<AnalyticsError, List<EffectiveCampaignEntity>>> getEffectiveCampaigns() =>
      _guard(() => remoteDataSource.getEffectiveCampaigns());

  @override
  Future<Either<AnalyticsError, CampaignAnalyticsEntity>> getCampaignAnalytics(CampaignEntity campaign) =>
      _guard(() => remoteDataSource.getCampaignAnalytics(campaign));
}
