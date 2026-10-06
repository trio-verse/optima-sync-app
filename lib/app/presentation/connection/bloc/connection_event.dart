import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadConnections extends ConnectionEvent {
  final String clientId;

  const LoadConnections({required this.clientId});

  @override
  List<Object?> get props => [clientId];
}

class LoadAllConnections extends ConnectionEvent {
  const LoadAllConnections();
}

class AddConnectionSubmitted extends ConnectionEvent {
  final String clientId;
  final ConnectionEntity connection;

  const AddConnectionSubmitted({
    required this.clientId,
    required this.connection,
  });

  @override
  List<Object?> get props => [clientId, connection];
}

class UpdateConnectionSubmitted extends ConnectionEvent {
  final String id;
  final String clientId;
  final ConnectionEntity connection;

  const UpdateConnectionSubmitted({
    required this.id,
    required this.clientId,
    required this.connection,
  });

  @override
  List<Object?> get props => [id, clientId, connection];
}

class UpdateConnectionStageSubmitted extends ConnectionEvent {
  final String id;
  final String clientId;
  final String stage;

  const UpdateConnectionStageSubmitted({
    required this.id,
    required this.clientId,
    required this.stage,
  });

  @override
  List<Object?> get props => [id, clientId, stage];
}

class DeleteConnectionSubmitted extends ConnectionEvent {
  final String id;
  final String clientId;

  const DeleteConnectionSubmitted({required this.id, required this.clientId});

  @override
  List<Object?> get props => [id, clientId];
}
