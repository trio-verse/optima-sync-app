part of 'connection_bloc.dart';

enum ConnectionSuccessType { created, updated, deleted }

@freezed
class ConnectionState with _$ConnectionState {
  const factory ConnectionState.initial() = ConnectionInitial;

  const factory ConnectionState.loading() = ConnectionLoading;

  const factory ConnectionState.submitting({
    required List<ConnectionEntity> connections,
  }) = ConnectionSubmitting;

  const factory ConnectionState.success({
    required List<ConnectionEntity> connections,
    ConnectionSuccessType? successType,
  }) = ConnectionSuccess;

  const factory ConnectionState.failure({required ConnectionError error}) =
      ConnectionFailure;
}
