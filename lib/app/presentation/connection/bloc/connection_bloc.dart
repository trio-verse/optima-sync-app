import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/connection_usecases.dart';

import 'package:optima_sync_v2/core/errors/connection/connection_errors.dart';
import 'connection_event.dart';
import 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final ConnectionUsecases usecases;

  String? _lastLoadedClientId;
  bool _loadedAll = false;

  ConnectionBloc({required this.usecases}) : super(ConnectionInitial()) {
    on<LoadConnections>(_onLoadConnections);
    on<LoadAllConnections>(_onLoadAllConnections);
    on<AddConnectionSubmitted>(_onAddConnectionSubmitted);
    on<UpdateConnectionSubmitted>(_onUpdateConnectionSubmitted);

    on<DeleteConnectionSubmitted>(_onDeleteConnectionSubmitted);
  }

  Future<List<ConnectionEntity>> _refreshCurrentList({
    required List<ConnectionEntity> orElse,
  }) async {
    if (_loadedAll) {
      final result = await usecases.getAllConnections();
      return result.fold((_) => orElse, (list) => list);
    }

    if (_lastLoadedClientId != null) {
      final result = await usecases.getClientConnections(_lastLoadedClientId!);
      return result.fold((_) => orElse, (list) => list);
    }

    return orElse;
  }

  List<ConnectionEntity> _currentConnections() {
    final currentState = state;

    if (currentState is ConnectionSuccess) {
      return currentState.connections;
    }

    if (currentState is ConnectionSubmitting) {
      return currentState.connections;
    }

    return const [];
  }

  Future<void> _onLoadConnections(
    LoadConnections event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(ConnectionLoading());

    final result = await usecases.getClientConnections(event.clientId);

    result.fold(
      (failure) => emit(ConnectionFailure(message: _messageFor(failure))),
      (connections) {
        _lastLoadedClientId = event.clientId;
        _loadedAll = false;
        emit(ConnectionSuccess(connections: connections));
      },
    );
  }

  Future<void> _onLoadAllConnections(
    LoadAllConnections event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(ConnectionLoading());

    final result = await usecases.getAllConnections();

    result.fold(
      (failure) => emit(ConnectionFailure(message: _messageFor(failure))),
      (connections) {
        _lastLoadedClientId = null;
        _loadedAll = true;
        emit(ConnectionSuccess(connections: connections));
      },
    );
  }

  Future<void> _onAddConnectionSubmitted(
    AddConnectionSubmitted event,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _currentConnections();

    emit(ConnectionSubmitting(connections: existing));

    if (event.connection.productId.trim().isEmpty) {
      emit(
        ConnectionFailure(
          message: 'Product is required',
          connections: existing,
        ),
      );
      return;
    }

    final createResult = await usecases.createConnection(event.connection);

    await createResult.fold(
      (failure) async => emit(
        ConnectionFailure(message: _messageFor(failure), connections: existing),
      ),
      (created) async {
        final connections = await _refreshCurrentList(
          orElse: [created, ...existing],
        );

        emit(
          ConnectionSuccess(
            connections: connections,
            message: 'Connection created successfully',
          ),
        );
      },
    );
  }

  Future<void> _onUpdateConnectionSubmitted(
    UpdateConnectionSubmitted event,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _currentConnections();

    emit(ConnectionSubmitting(connections: existing));

    if (event.connection.productId.trim().isEmpty) {
      emit(
        ConnectionFailure(
          message: 'Product is required',
          connections: existing,
        ),
      );
      return;
    }

    final updateResult = await usecases.updateConnection(event.connection);
    await updateResult.fold(
      (failure) async => emit(
        ConnectionFailure(message: _messageFor(failure), connections: existing),
      ),
      (updated) async {
        final connections = await _refreshCurrentList(
          orElse: [
            for (final c in existing)
              if (c.id == updated.id) updated else c,
          ],
        );

        emit(
          ConnectionSuccess(
            connections: connections,
            message: 'Connection updated successfully',
          ),
        );
      },
    );
  }

  Future<void> _onDeleteConnectionSubmitted(
    DeleteConnectionSubmitted event,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _currentConnections();

    emit(ConnectionSubmitting(connections: existing));

    final result = await usecases.deleteConnection(event.id);

    result.fold(
      (failure) => emit(
        ConnectionFailure(message: _messageFor(failure), connections: existing),
      ),
      (_) {
        final updatedConnections = existing
            .where((connection) => connection.id != event.id)
            .toList();
        emit(
          ConnectionSuccess(
            connections: updatedConnections,
            message: 'Connection deleted successfully',
          ),
        );
      },
    );
  }

  String _messageFor(ConnectionError error) {
    return error.when(
      serverError: () => 'Server error, please try again',
      connectionOffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
