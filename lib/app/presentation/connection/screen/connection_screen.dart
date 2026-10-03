import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_state.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/add_connection_form.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/connection_list_item.dart';

class ConnectionScreen extends StatefulWidget {
  final ClientEntity client;

  const ConnectionScreen({super.key, required this.client});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  String get _clientId => widget.client.id!;

  @override
  void initState() {
    super.initState();

    context.read<ConnectionBloc>().add(LoadConnections(clientId: _clientId));
  }

  void _openAddConnectionForm() {
    final bloc = context.read<ConnectionBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: AddConnectionForm(clientId: _clientId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.client.name} · Connections')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddConnectionForm,
        icon: const Icon(Icons.add),
        label: const Text("New Connection"),
      ),

      body: BlocConsumer<ConnectionBloc, ConnectionState>(
        listener: (context, state) {
          if (state is ConnectionSuccess && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }

          if (state is ConnectionFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          if (state is ConnectionInitial || state is ConnectionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ConnectionFailure && state.connections == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ConnectionBloc>().add(
                          LoadConnections(clientId: _clientId),
                        );
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          final connections = switch (state) {
            ConnectionSuccess(:final connections) => connections,
            ConnectionSubmitting(:final connections) => connections,
            ConnectionFailure(:final connections) => connections ?? const [],
            _ => const [],
          };

          if (connections.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.hub_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    const Text("No connections yet"),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _openAddConnectionForm,
                      icon: const Icon(Icons.add),
                      label: const Text("New Connection"),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: connections.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ConnectionListItem(
                clientId: _clientId,
                connection: connections[index],
              );
            },
          );
        },
      ),
    );
  }
}
