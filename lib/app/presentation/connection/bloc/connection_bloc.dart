import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/connection_usecases.dart';
import 'package:optima_sync_v2/core/errors/connection/connection_errors.dart';

part 'connection_bloc.freezed.dart';
part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final ConnectionUsecases usecases;

  String? _lastLoadedClientId;
  bool _loadedAll = false;

  ConnectionBloc({required this.usecases}) : super(.initial()) {
    on<ConnectionEvent>((event, emit) async {
      await event.when(
        loadConnections: (clientId) => _onLoadConnections(clientId, emit),
        loadAllConnections: () => _onLoadAllConnections(emit),
        addSubmitted: (connection) => _onAddSubmitted(connection, emit),
        updateSubmitted: (connection) => _onUpdateSubmitted(connection, emit),
        deleteSubmitted: (id) => _onDeleteSubmitted(id, emit),
      );
    });
  }

  String _messageFor(ConnectionError error) {
    return error.when(
      offline: () => 'No internet connection',
      sessionExpired: () => 'Your session has expired, please log in again',
      noOrganization: () => 'Please select an organization first',
      invalidData: () =>
          'The submitted data is invalid, please check it and try again',
      notFound: () => 'This connection no longer exists',
      serverError: () => 'Something went wrong, please try again',
    );
  }

  List<ConnectionEntity> _currentConnections() {
    return switch (state) {
      ConnectionSuccess(:final connections) ||
      ConnectionSubmitting(:final connections) => connections,
      _ => const [],
    };
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

  Future<void> _onLoadConnections(
    String clientId,
    Emitter<ConnectionState> emit,
  ) async {
    emit(.loading());

    final result = await usecases.getClientConnections(clientId);

    result.fold((failure) => emit(.failure(message: _messageFor(failure))), (
      connections,
    ) {
      _lastLoadedClientId = clientId;
      _loadedAll = false;
      emit(.success(connections: connections));
    });
  }

  Future<void> _onLoadAllConnections(Emitter<ConnectionState> emit) async {
    emit(.loading());

    final result = await usecases.getAllConnections();

    result.fold((failure) => emit(.failure(message: _messageFor(failure))), (
      connections,
    ) {
      _lastLoadedClientId = null;
      _loadedAll = true;
      emit(.success(connections: connections));
    });
  }

  Future<void> _onAddSubmitted(
    ConnectionEntity connection,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _currentConnections();

    emit(.submitting(connections: existing));
    if (connection.productId.trim().isEmpty) {
      emit(.failure(message: 'Product is required', connections: existing));
      return;
    }

    final createResult = await usecases.createConnection(connection);

    await createResult.fold(
      (failure) async =>
          emit(.failure(message: _messageFor(failure), connections: existing)),
      (created) async {
        final connections = await _refreshCurrentList(
          orElse: [created, ...existing],
        );

        emit(
          .success(
            connections: connections,
            message: 'Connection created successfully',
          ),
        );
      },
    );
  }

  Future<void> _onUpdateSubmitted(
    ConnectionEntity connection,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _currentConnections();

    emit(.submitting(connections: existing));

    if (connection.productId.trim().isEmpty) {
      emit(.failure(message: 'Product is required', connections: existing));
      return;
    }
    final updateResult = await usecases.updateConnection(connection);

    await updateResult.fold(
      (failure) async =>
          emit(.failure(message: _messageFor(failure), connections: existing)),
      (updated) async {
        final connections = await _refreshCurrentList(
          orElse: [
            for (final c in existing)
              if (c.id == updated.id) updated else c,
          ],
        );

        emit(
          .success(
            connections: connections,
            message: 'Connection updated successfully',
          ),
        );
      },
    );
  }

  Future<void> _onDeleteSubmitted(
    String id,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _currentConnections();

    emit(.submitting(connections: existing));

    final result = await usecases.deleteConnection(id);

    result.fold(
      (failure) =>
          emit(.failure(message: _messageFor(failure), connections: existing)),
      (_) {
        final remaining = existing.where((c) => c.id != id).toList();

        emit(
          .success(
            connections: remaining,
            message: 'Connection deleted successfully',
          ),
        );
      },
    );
  }
}
