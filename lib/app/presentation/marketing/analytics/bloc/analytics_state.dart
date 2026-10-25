part of 'analytics_bloc.dart';

@freezed
class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState.initial() = AnalyticsInitial;

  const factory AnalyticsState.loading() = AnalyticsLoading;

  const factory AnalyticsState.dashboardLoaded({
    required MarketingDashboardEntity dashboard,
    required List<EffectiveCampaignEntity> effectiveCampaigns,
  }) = MarketingDashboardLoaded;

  const factory AnalyticsState.campaignAnalyticsLoaded({required CampaignAnalyticsEntity analytics}) =
      CampaignAnalyticsLoaded;

  const factory AnalyticsState.failure({required AnalyticsError failure}) = AnalyticsFailure;
}
