import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/client_usecases.dart';

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

    try {
      final result = await usecases.getClients(filter);

      emit(
        ClientSuccess(
          clients: result.clients,
          filter: filter,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      emit(ClientFailure(message: e.toString(), filter: filter));
    }
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

    emit(currentState.copyWith(isLoadingMore: true));

    final nextFilter = currentState.filter.copyWith(
      page: currentState.filter.page + 1,
    );

    try {
      final result = await usecases.getClients(nextFilter);

      emit(
        ClientSuccess(
          clients: [...currentState.clients, ...result.clients],
          filter: nextFilter,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      emit(
        ClientFailure(
          message: e.toString(),
          clients: currentState.clients,
          filter: currentState.filter,
        ),
      );
      emit(currentState.copyWith(isLoadingMore: false));
    }
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

    try {
      await usecases.createClient(event.client);

      final result = await usecases.getClients(filter);

      emit(
        ClientSuccess(
          clients: result.clients,
          filter: filter,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      emit(
        ClientFailure(
          message: e.toString(),
          clients: existingClients,
          filter: filter,
        ),
      );
    }
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

    try {
      await usecases.updateClient(id: event.id, client: event.client);

      final result = await usecases.getClients(filter.copyWith(page: 1));

      emit(
        ClientSuccess(
          clients: result.clients,
          filter: filter.copyWith(page: 1),
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      emit(
        ClientFailure(
          message: e.toString(),
          clients: existingClients,
          filter: filter,
        ),
      );
    }
  }
}
