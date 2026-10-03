import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';

abstract class CampaignEvent extends Equatable {
  const CampaignEvent();

  @override
  List<Object?> get props => [];
}

class LoadCampaigns extends CampaignEvent {}

class AddCampaignSubmitted extends CampaignEvent {
  final CampaignEntity campaign;

  const AddCampaignSubmitted({required this.campaign});

  @override
  List<Object?> get props => [campaign];
}

class UpdateCampaignSubmitted extends CampaignEvent {
  final String id;
  final CampaignEntity campaign;

  const UpdateCampaignSubmitted({required this.id, required this.campaign});

  @override
  List<Object?> get props => [id, campaign];
}

class DeleteCampaignSubmitted extends CampaignEvent {
  final String id;

  const DeleteCampaignSubmitted({required this.id});

  @override
  List<Object?> get props => [id];
}
