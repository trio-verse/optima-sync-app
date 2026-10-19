import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarketingDashboard extends AnalyticsEvent {}

class LoadCampaignAnalytics extends AnalyticsEvent {
  final CampaignEntity campaign;
  const LoadCampaignAnalytics({
    required this.campaign,
    required String campaignId,
  });
  @override
  List<Object?> get props => [campaign.id];
}
