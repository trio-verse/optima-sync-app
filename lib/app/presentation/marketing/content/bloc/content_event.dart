part of 'content_bloc.dart';

@freezed
class ContentEvent with _$ContentEvent {
  const factory ContentEvent.getAllCampaignContents({required String campaignId}) = _GetAllCampaignContents;
  const factory ContentEvent.addCampaignContent({required ContentEntity content}) = _AddCampaignContent;
  const factory ContentEvent.updateCampaignContent({required ContentEntity content}) = _UpdateCampaignContent;
  const factory ContentEvent.deleteCampaignContent({required ContentEntity content}) = _DeleteCampaignContent;
}
