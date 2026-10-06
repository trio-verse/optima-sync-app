import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/client_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientUsecases usecases;

  ClientBloc({required this.usecases}) : super(ClientInitial()) {
    on<LoadClients>(_onLoadClients);
    on<LoadMoreClients>(_onLoadMoreClients);
    on<AddClientSubmitted>(_onAddClientSubmitted);
    on<UpdateClientSubmitted>(_onUpdateClientSubmitted);
  }

  ClientFilter _currentFilter() {
    final currentState = state;
    if (currentState is ClientSuccess) return currentState.filter;
    if (currentState is ClientSubmitting) return currentState.filter;
    if (currentState is ClientFailure && currentState.filter != null) {
      return currentState.filter!;
    }
    return const ClientFilter();
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientState> emit,
  ) async {
    final filter = (event.filter ?? _currentFilter()).copyWith(page: 1);
    emit(ClientLoading());

    final result = await usecases.getClients(filter);

    result.fold(
      (l) => emit(ClientFailure(message: _messageFor(l), filter: filter)),
      (r) => emit(
        ClientSuccess(clients: r.clients, filter: filter, hasMore: r.hasMore),
      ),
    );
  }

  Future<void> _onLoadMoreClients(
    LoadMoreClients event,
    Emitter<ClientState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ClientSuccess ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }
    emit(currentState.copyWith(isLoadingMore: true, clearCreatedClient: true));
    final nextFilter = currentState.filter.copyWith(
      page: currentState.filter.page + 1,
    );

    final result = await usecases.getClients(nextFilter);

    result.fold(
      (l) => emit(
        ClientFailure(
          message: _messageFor(l),
          clients: currentState.clients,
          filter: currentState.filter,
        ),
      ),
      (r) => emit(
        ClientSuccess(
          clients: [...currentState.clients, ...r.clients],
          filter: nextFilter,
          hasMore: r.hasMore,
        ),
      ),
    );
  }

  Future<void> _onAddClientSubmitted(
    AddClientSubmitted event,
    Emitter<ClientState> emit,
  ) async {
    final filter = _currentFilter().copyWith(page: 1);
    final existingClients = state is ClientSuccess
        ? (state as ClientSuccess).clients
        : const <ClientEntity>[];
    emit(ClientSubmitting(clients: existingClients, filter: filter));

    final createResult = await usecases.createClient(event.client);

    await createResult.fold(
      (l) async => emit(
        ClientFailure(
          message: _messageFor(l),
          clients: existingClients,
          filter: filter,
        ),
      ),
      (created) async {
        final listResult = await usecases.getClients(filter);
        listResult.fold(
          (_) => emit(
            ClientSuccess(
              clients: [created, ...existingClients],
              filter: filter,
              hasMore: false,
              createdClient: created,
            ),
          ),
          (r) => emit(
            ClientSuccess(
              clients: r.clients,
              filter: filter,
              hasMore: r.hasMore,
              createdClient: created,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onUpdateClientSubmitted(
    UpdateClientSubmitted event,
    Emitter<ClientState> emit,
  ) async {
    final filter = _currentFilter();
    final existingClients = state is ClientSuccess
        ? (state as ClientSuccess).clients
        : const <ClientEntity>[];
    emit(ClientSubmitting(clients: existingClients, filter: filter));

    final updateResult = await usecases.updateClient(
      id: event.id,
      client: event.client,
    );

    await updateResult.fold(
      (l) async => emit(
        ClientFailure(
          message: _messageFor(l),
          clients: existingClients,
          filter: filter,
        ),
      ),
      (_) async {
        final refreshedFilter = filter.copyWith(page: 1);
        final listResult = await usecases.getClients(refreshedFilter);
        listResult.fold(
          (l) => emit(
            ClientFailure(
              message: _messageFor(l),
              clients: existingClients,
              filter: filter,
            ),
          ),
          (r) => emit(
            ClientSuccess(
              clients: r.clients,
              filter: refreshedFilter,
              hasMore: r.hasMore,
            ),
          ),
        );
      },
    );
  }

  String _messageFor(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'Server error, please try again',
      whatoffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
