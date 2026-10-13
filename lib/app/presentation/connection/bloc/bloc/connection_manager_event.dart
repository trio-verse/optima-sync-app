part of 'connection_manager_bloc.dart';

@freezed
class ConnectionManagerEvent with _$ConnectionManagerEvent {
  const factory ConnectionManagerEvent.started() = _Started;
}