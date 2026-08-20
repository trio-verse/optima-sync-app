import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientEvent {
  final ClientFilter? filter;

  const LoadClients({this.filter});

  @override
  List<Object?> get props => [filter];
}

class LoadMoreClients extends ClientEvent {}

class AddClientSubmitted extends ClientEvent {
  final ClientEntity client;

  const AddClientSubmitted({required this.client});

  @override
  List<Object?> get props => [client];
}

class UpdateClientSubmitted extends ClientEvent {
  final String id;
  final ClientEntity client;

  const UpdateClientSubmitted({required this.id, required this.client});

  @override
  List<Object?> get props => [id, client];
}
