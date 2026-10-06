import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';

abstract class CampaignState extends Equatable {
  const CampaignState();

  @override
  List<Object?> get props => [];
}

class CampaignInitial extends CampaignState {}

class CampaignLoading extends CampaignState {}

class CampaignSuccess extends CampaignState {
  final List<CampaignEntity> campaigns;

  const CampaignSuccess({required this.campaigns});

  @override
  List<Object?> get props => [campaigns];
}

class CampaignFailure extends CampaignState {
  final String message;
  final List<CampaignEntity>? campaigns;

  const CampaignFailure({required this.message, this.campaigns});

  @override
  List<Object?> get props => [message, campaigns];
}
