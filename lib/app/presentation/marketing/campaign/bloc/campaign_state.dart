part of 'campaign_bloc.dart';

enum CampaignSuccessType { created, updated, deleted }

@freezed
class CampaignState with _$CampaignState {
  const factory CampaignState.initial() = CampaignInitial;

  const factory CampaignState.loading() = CampaignLoading;

  const factory CampaignState.submitting({
    required List<CampaignEntity> campaigns,
  }) = CampaignSubmitting;

  const factory CampaignState.success({
    required List<CampaignEntity> campaigns,
    CampaignSuccessType? successType,
  }) = CampaignSuccess;

  const factory CampaignState.failure({required MarketingError error}) =
      CampaignFailure;
}
