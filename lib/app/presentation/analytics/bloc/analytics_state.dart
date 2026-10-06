import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/analytics_entity.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class MarketingDashboardLoaded extends AnalyticsState {
  final MarketingDashboardEntity dashboard;
  final List<EffectiveCampaignEntity> effectiveCampaigns;

  const MarketingDashboardLoaded({
    required this.dashboard,
    required this.effectiveCampaigns,
  });

  @override
  List<Object?> get props => [dashboard, effectiveCampaigns];
}

class CampaignAnalyticsLoaded extends AnalyticsState {
  final CampaignAnalyticsEntity analytics;

  const CampaignAnalyticsLoaded({required this.analytics});

  @override
  List<Object?> get props => [analytics];
}

class AnalyticsFailure extends AnalyticsState {
  final String message;

  const AnalyticsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
