import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_errors.freezed.dart';

@freezed
abstract class ConnectionError with _$ConnectionError {
  const factory ConnectionError.offline() = _Offline;
  const factory ConnectionError.sessionExpired() = _SessionExpired;
  const factory ConnectionError.noOrganization() = _NoOrganization;
  const factory ConnectionError.invalidData() = _InvalidData;
  const factory ConnectionError.notFound() = _NotFound;
  const factory ConnectionError.serverError() = _ServerError;
  const factory ConnectionError.productRequired() = _ProductRequired;
}
