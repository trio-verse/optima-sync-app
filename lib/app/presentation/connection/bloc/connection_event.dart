import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';

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
  final ConnectionEntity connection;
  const AddConnectionSubmitted({required this.connection});
  @override
  List<Object?> get props => [connection];
}

class UpdateConnectionSubmitted extends ConnectionEvent {
  final ConnectionEntity connection;
  const UpdateConnectionSubmitted({required this.connection});
  @override
  List<Object?> get props => [connection];
}

class DeleteConnectionSubmitted extends ConnectionEvent {
  final String id;
  const DeleteConnectionSubmitted({required this.id});
  @override
  List<Object?> get props => [id];
}
