import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';

abstract class ConnectionState extends Equatable {
  const ConnectionState();

  @override
  List<Object?> get props => [];
}

class ConnectionInitial extends ConnectionState {}

class ConnectionLoading extends ConnectionState {}

class ConnectionSubmitting extends ConnectionState {
  final List<ConnectionEntity> connections;

  const ConnectionSubmitting({required this.connections});

  @override
  List<Object?> get props => [connections];
}

class ConnectionSuccess extends ConnectionState {
  final List<ConnectionEntity> connections;

  final String? message;

  const ConnectionSuccess({required this.connections, this.message});

  @override
  List<Object?> get props => [connections, message];
}

class ConnectionFailure extends ConnectionState {
  final String message;
  final List<ConnectionEntity>? connections;

  const ConnectionFailure({required this.message, this.connections});

  @override
  List<Object?> get props => [message, connections];
}
