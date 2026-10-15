part of 'connection_bloc.dart';

@freezed
class ConnectionEvent with _$ConnectionEvent {
  const factory ConnectionEvent.loadConnections({required String clientId}) =
      LoadConnections;

  const factory ConnectionEvent.loadAllConnections() = LoadAllConnections;

  const factory ConnectionEvent.addSubmitted({
    required ConnectionEntity connection,
  }) = AddConnectionSubmitted;

  const factory ConnectionEvent.updateSubmitted({
    required ConnectionEntity connection,
  }) = UpdateConnectionSubmitted;

  const factory ConnectionEvent.deleteSubmitted({required String id}) =
      DeleteConnectionSubmitted;
}
