import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketing_errors.freezed.dart';

@freezed
abstract class CampaignError with _$CampaignError {
  const factory CampaignError.offline() = _Offline;
  const factory CampaignError.sessionExpired() = _SessionExpired;
  const factory CampaignError.noOrganization() = _NoOrganization;
  const factory CampaignError.invalidData() = _InvalidData;
  const factory CampaignError.notFound() = _NotFound;
  const factory CampaignError.serverError() = _ServerError;
}

@freezed
abstract class ContentError with _$ContentError {
  const factory ContentError.offline() = _ContentOffline;
  const factory ContentError.sessionExpired() = _ContentSessionExpired;
  const factory ContentError.noOrganization() = _ContentNoOrganization;
  const factory ContentError.invalidData() = _ContentInvalidData;
  const factory ContentError.notFound() = _ContentNotFound;
  const factory ContentError.serverError() = _ContentServerError;
}

@freezed
abstract class AnalyticsError with _$AnalyticsError {
  const factory AnalyticsError.offline() = _AnalyticsOffline;
  const factory AnalyticsError.sessionExpired() = _AnalyticsSessionExpired;
  const factory AnalyticsError.noOrganization() = _AnalyticsNoOrganization;
  const factory AnalyticsError.invalidData() = _AnalyticsInvalidData;
  const factory AnalyticsError.notFound() = _AnalyticsNotFound;
  const factory AnalyticsError.serverError() = _AnalyticsServerError;
}
