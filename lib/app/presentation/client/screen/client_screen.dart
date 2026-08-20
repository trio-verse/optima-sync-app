import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_bloc.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_event.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_state.dart';
import 'package:optima_sync_v2/app/presentation/client/pages/add_client_form.dart';
import 'package:optima_sync_v2/app/presentation/client/pages/client_filter_sheet.dart';
import 'package:optima_sync_v2/app/presentation/client/pages/client_list_item.dart';
import 'package:optima_sync_v2/app/presentation/client/pages/edit_client_form.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    context.read<ClientBloc>().add(const LoadClients(filter: ClientFilter()));

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<ClientBloc>().add(LoadMoreClients());
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  ClientFilter _currentFilter() {
    final state = context.read<ClientBloc>().state;

    if (state is ClientSuccess) return state.filter;
    if (state is ClientSubmitting) return state.filter;
    if (state is ClientFailure && state.filter != null) return state.filter!;

    return const ClientFilter();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final filter = _currentFilter().copyWith(name: value, page: 1);

      context.read<ClientBloc>().add(LoadClients(filter: filter));
    });
  }

  Future<void> _openFilters() async {
    final bloc = context.read<ClientBloc>();

    final result = await showModalBottomSheet<ClientFilter>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return ClientFilterSheet(initialFilter: _currentFilter());
      },
    );

    if (result != null) {
      searchController.text = result.name;
      bloc.add(LoadClients(filter: result));
    }
  }

  void _openAddClientForm() {
    final bloc = context.read<ClientBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(value: bloc, child: const AddClientForm());
      },
    );
  }

  void _openEditClientForm(ClientEntity client) {
    final bloc = context.read<ClientBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: EditClientForm(client: client),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddClientForm,
        icon: const Icon(Icons.add),
        label: const Text('Add Client'),
      ),

      body: BlocConsumer<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          final filter = state is ClientSuccess
              ? state.filter
              : state is ClientSubmitting
              ? state.filter
              : state is ClientFailure
              ? (state.filter ?? const ClientFilter())
              : const ClientFilter();

          final hasActiveFilters = !filter.isEmpty;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search clients',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    _onSearchChanged('');
                                  },
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Badge(
                      isLabelVisible: hasActiveFilters,
                      child: IconButton.filledTonal(
                        onPressed: _openFilters,
                        icon: const Icon(Icons.filter_list),
                      ),
                    ),
                  ],
                ),
              ),

              if (state is ClientLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is ClientFailure && state.clients == null)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ClientBloc>().add(
                                const LoadClients(filter: ClientFilter()),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final clients = switch (state) {
                        ClientSuccess(:final clients) => clients,
                        ClientSubmitting(:final clients) => clients,
                        ClientFailure(:final clients) => clients ?? const [],
                        _ => const <ClientEntity>[],
                      };

                      final isSubmitting = state is ClientSubmitting;

                      final isLoadingMore =
                          state is ClientSuccess && state.isLoadingMore;

                      if (clients.isEmpty) {
                        return Center(
                          child: Text(
                            hasActiveFilters
                                ? 'No clients match your filters'
                                : 'No clients yet',
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: clients.length + (isLoadingMore ? 1 : 0),
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          if (index >= clients.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }

                          final client = clients[index];

                          return ClientListItem(
                            client: client,
                            isLoading: isSubmitting,
                            onEdit: isSubmitting
                                ? null
                                : () => _openEditClientForm(client),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
