part of 'analytics_bloc.dart';

@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent.loadDashboard() = LoadMarketingDashboard;

  const factory AnalyticsEvent.loadCampaignAnalytics({required CampaignEntity campaign}) = LoadCampaignAnalytics;
}
