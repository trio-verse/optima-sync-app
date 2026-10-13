import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_errors.freezed.dart';

@freezed
abstract class ConnectionError with _$ConnectionError {
  const factory ConnectionError.serverError() = _ServerError;

  const factory ConnectionError.connectionOffline() = _ConnectionOffline;

  const factory ConnectionError.database() = _Database;
}
