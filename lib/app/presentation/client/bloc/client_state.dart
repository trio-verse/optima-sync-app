import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object?> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientSuccess extends ClientState {
  final List<ClientEntity> clients;
  final ClientFilter filter;
  final bool hasMore;
  final bool isLoadingMore;

  const ClientSuccess({
    required this.clients,
    required this.filter,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  ClientSuccess copyWith({
    List<ClientEntity>? clients,
    ClientFilter? filter,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ClientSuccess(
      clients: clients ?? this.clients,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [clients, filter, hasMore, isLoadingMore];
}

class ClientSubmitting extends ClientState {
  final List<ClientEntity> clients;
  final ClientFilter filter;

  const ClientSubmitting({required this.clients, required this.filter});

  @override
  List<Object?> get props => [clients, filter];
}

class ClientFailure extends ClientState {
  final String message;
  final List<ClientEntity>? clients;
  final ClientFilter? filter;

  const ClientFailure({required this.message, this.clients, this.filter});

  @override
  List<Object?> get props => [message, clients, filter];
}
