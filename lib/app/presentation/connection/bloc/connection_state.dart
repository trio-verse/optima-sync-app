part of 'connection_bloc.dart';

@freezed
class ConnectionState with _$ConnectionState {
  const factory ConnectionState.initial() = ConnectionInitial;

  const factory ConnectionState.loading() = ConnectionLoading;

  const factory ConnectionState.submitting({
    required List<ConnectionEntity> connections,
  }) = ConnectionSubmitting;

  const factory ConnectionState.success({
    required List<ConnectionEntity> connections,
    String? message,
  }) = ConnectionSuccess;

  const factory ConnectionState.failure({
    required String message,
    List<ConnectionEntity>? connections,
  }) = ConnectionFailure;
}
