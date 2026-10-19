import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketing_errors.freezed.dart';

@freezed
abstract class MarketingError with _$MarketingError {
  const factory MarketingError.offline() = _Offline;
  const factory MarketingError.sessionExpired() = _SessionExpired;
  const factory MarketingError.noOrganization() = _NoOrganization;
  const factory MarketingError.invalidData() = _InvalidData;
  const factory MarketingError.notFound() = _NotFound;
  const factory MarketingError.serverError() = _ServerError;
}
