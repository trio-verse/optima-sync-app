import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarketingDashboard extends AnalyticsEvent {}

class LoadCampaignAnalytics extends AnalyticsEvent {
  final String campaignId;

  const LoadCampaignAnalytics({required this.campaignId});

  @override
  List<Object?> get props => [campaignId];
}
