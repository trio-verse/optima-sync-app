import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optima_sync_v2/app/domain/entities/sales/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/sales/connection_usecases.dart';
import 'package:optima_sync_v2/core/errors/connection/connection_errors.dart';

part 'connection_bloc.freezed.dart';
part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final ConnectionUsecases usecases;

  List<ConnectionEntity> _connections = const [];
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

    result.fold((failure) => emit(.failure(error: failure)), (connections) {
      _lastLoadedClientId = clientId;
      _loadedAll = false;
      _connections = connections;
      emit(.success(connections: connections));
    });
  }

  Future<void> _onLoadAllConnections(Emitter<ConnectionState> emit) async {
    emit(.loading());

    final result = await usecases.getAllConnections();

    result.fold((failure) => emit(.failure(error: failure)), (connections) {
      _lastLoadedClientId = null;
      _loadedAll = true;
      _connections = connections;
      emit(.success(connections: connections));
    });
  }

  Future<void> _onAddSubmitted(
    ConnectionEntity connection,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _connections;

    emit(.submitting(connections: existing));

    final createResult = await usecases.createConnection(connection);

    await createResult.fold((failure) async => emit(.failure(error: failure)), (
      created,
    ) async {
      _connections = await _refreshCurrentList(orElse: [created, ...existing]);

      emit(
        .success(
          connections: _connections,
          successType: ConnectionSuccessType.created,
        ),
      );
    });
  }

  Future<void> _onUpdateSubmitted(
    ConnectionEntity connection,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _connections;

    emit(.submitting(connections: existing));

    final updateResult = await usecases.updateConnection(connection);

    await updateResult.fold((failure) async => emit(.failure(error: failure)), (
      updated,
    ) async {
      _connections = await _refreshCurrentList(
        orElse: [
          for (final c in existing)
            if (c.id == updated.id) updated else c,
        ],
      );

      emit(
        .success(
          connections: _connections,
          successType: ConnectionSuccessType.updated,
        ),
      );
    });
  }

  Future<void> _onDeleteSubmitted(
    String id,
    Emitter<ConnectionState> emit,
  ) async {
    final existing = _connections;

    emit(.submitting(connections: existing));

    final result = await usecases.deleteConnection(id);

    result.fold((failure) => emit(.failure(error: failure)), (_) {
      _connections = existing.where((c) => c.id != id).toList();

      emit(
        .success(
          connections: _connections,
          successType: ConnectionSuccessType.deleted,
        ),
      );
    });
  }
}
