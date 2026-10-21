part of 'campaign_bloc.dart';

@freezed
class CampaignEvent with _$CampaignEvent {
  const factory CampaignEvent.loadCampaigns() = LoadCampaigns;

  const factory CampaignEvent.addSubmitted({required CampaignEntity campaign}) =
      AddCampaignSubmitted;

  const factory CampaignEvent.updateSubmitted({
    required CampaignEntity campaign,
  }) = UpdateCampaignSubmitted;

  const factory CampaignEvent.deleteSubmitted({
    required CampaignEntity campaign,
  }) = DeleteCampaignSubmitted;
}
