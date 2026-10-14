import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_errors.freezed.dart';

@freezed
abstract class ConnectionError with _$ConnectionError {
  const factory ConnectionError.serverError() = _ServerError;

  const factory ConnectionError.connectionOffline() = _ConnectionOffline;

  const factory ConnectionError.badRequest() = _BadRequest;

  const factory ConnectionError.notFound() = _NotFound;

  const factory ConnectionError.noContent() = _NoContent;

  const factory ConnectionError.unauthorized() = _Unauthorized;

  const factory ConnectionError.unexpected() = _Unexpected;

  const factory ConnectionError.database() = _Database;
}
