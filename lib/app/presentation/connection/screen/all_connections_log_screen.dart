import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_state.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/connection_log_item.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/new_connection_flow_dialog.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class AllConnectionsLogScreen extends StatefulWidget {
  const AllConnectionsLogScreen({super.key});

  @override
  State<AllConnectionsLogScreen> createState() =>
      _AllConnectionsLogScreenState();
}

class _AllConnectionsLogScreenState extends State<AllConnectionsLogScreen> {
  final _searchController = TextEditingController();
  String? _selectedStage;

  static const _allStagesValue = '__all_stages__';

  @override
  void initState() {
    super.initState();
    context.read<ConnectionBloc>().add(const LoadAllConnections());
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ConnectionEntity> _applyFilters(List<ConnectionEntity> connections) {
    final query = _searchController.text.trim().toLowerCase();

    return connections.where((connection) {
      final matchesStage =
          _selectedStage == null || connection.stage == _selectedStage;
      if (!matchesStage) return false;
      if (query.isEmpty) return true;

      final client = (connection.clientName ?? '').toLowerCase();
      final product = (connection.productName ?? '').toLowerCase();
      return client.contains(query) || product.contains(query);
    }).toList();
  }

  Future<void> _openNewConnection() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const NewConnectionFlowDialog(),
    );

    if (!mounted || created != true) return;
    context.read<ConnectionBloc>().add(const LoadAllConnections());
  }

  Future<void> _openStageFilterSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _StageFilterSheet(
        selectedStage: _selectedStage,
        allStagesValue: _allStagesValue,
      ),
    );

    if (result == null) return;
    setState(() {
      _selectedStage = result == _allStagesValue ? null : result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.pageBackground,
      appBar: AppBar(
        backgroundColor: AppPallete.cardBackground,
        surfaceTintColor: AppPallete.cardBackground,
        elevation: 0,
        foregroundColor: AppPallete.textPrimary,
        title: const Text(
          'Sales',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<ConnectionBloc, ConnectionState>(
        listener: (context, state) {
          if (state is ConnectionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is ConnectionSuccess && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
        },
        builder: (context, state) {
          final isLoading =
              state is ConnectionInitial || state is ConnectionLoading;
          final isSubmitting = state is ConnectionSubmitting;

          final allConnections = switch (state) {
            ConnectionSuccess(:final connections) => connections,
            ConnectionSubmitting(:final connections) => connections,
            ConnectionFailure(:final connections) => connections ?? const [],
            _ => const <ConnectionEntity>[],
          };

          final filtered = _applyFilters(allConnections);
          final hasAnyData = allConnections.isNotEmpty;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ConnectionBloc>().add(const LoadAllConnections());
              await context.read<ConnectionBloc>().stream.firstWhere(
                (next) =>
                    next is ConnectionSuccess || next is ConnectionFailure,
              );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              children: [
                _HeaderCard(
                  onAddConnection: isSubmitting ? null : _openNewConnection,
                ),
                const SizedBox(height: 14),
                _ToolbarCard(
                  searchController: _searchController,
                  selectedStage: _selectedStage,
                  onStageChanged: (value) =>
                      setState(() => _selectedStage = value),
                  onOpenFilterSheet: _openStageFilterSheet,
                ),
                const SizedBox(height: 14),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 70),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (filtered.isEmpty)
                  _EmptyState(
                    hasAnyData: hasAnyData,
                    onAddConnection: _openNewConnection,
                  )
                else
                  for (final connection in filtered)
                    ConnectionLogItem(connection: connection),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final VoidCallback? onAddConnection;

  const _HeaderCard({required this.onAddConnection});

  @override
  Widget build(BuildContext context) {
    final title = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppPallete.salesPrimarySoft,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.link_rounded,
            color: AppPallete.salesPrimary,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Clients Connections Log',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppPallete.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage and track all interactions and stages across all clients in one place',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppPallete.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final action = FilledButton.icon(
      onPressed: onAddConnection,
      style: FilledButton.styleFrom(
        backgroundColor: AppPallete.salesPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text('Add Connection'),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 560) {
            return Row(
              children: [
                Expanded(child: title),
                const SizedBox(width: 16),
                action,
              ],
            );
          }

          return Column(
            children: [
              title,
              const SizedBox(height: 14),
              Align(alignment: Alignment.centerRight, child: action),
            ],
          );
        },
      ),
    );
  }
}

class _ToolbarCard extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedStage;
  final ValueChanged<String?> onStageChanged;
  final VoidCallback onOpenFilterSheet;

  const _ToolbarCard({
    required this.searchController,
    required this.selectedStage,
    required this.onStageChanged,
    required this.onOpenFilterSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final search = TextField(
            controller: searchController,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search by client or product name...',
              hintStyle: const TextStyle(
                color: AppPallete.textSecondary,
                fontSize: 12.5,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppPallete.textSecondary,
                size: 20,
              ),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: searchController.clear,
                    ),
              filled: true,
              fillColor: AppPallete.inputFill,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide.none,
              ),
            ),
          );

          final stage = Row(
            children: [
              InkWell(
                onTap: onOpenFilterSheet,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppPallete.inputFill,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.filter_list_rounded,
                    size: 20,
                    color: AppPallete.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppPallete.inputFill,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: selectedStage,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppPallete.textSecondary,
                      ),
                      style: const TextStyle(
                        color: AppPallete.textPrimary,
                        fontSize: 12.5,
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('All Stages'),
                        ),
                        ...ConnectionStage.values.map(
                          (stage) => DropdownMenuItem<String?>(
                            value: stage,
                            child: Text(ConnectionStage.label(stage)),
                          ),
                        ),
                      ],
                      onChanged: onStageChanged,
                    ),
                  ),
                ),
              ),
            ],
          );

          if (constraints.maxWidth >= 560) {
            return Row(
              children: [
                Expanded(flex: 3, child: search),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: stage),
              ],
            );
          }

          return Column(
            children: [
              search,
              const SizedBox(height: 10),
              stage,
            ],
          );
        },
      ),
    );
  }
}

class _StageFilterSheet extends StatelessWidget {
  final String? selectedStage;
  final String allStagesValue;

  const _StageFilterSheet({
    required this.selectedStage,
    required this.allStagesValue,
  });

  @override
  Widget build(BuildContext context) {
    final currentValue = selectedStage ?? allStagesValue;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                'Filter by Stage',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            RadioListTile<String>(
              value: allStagesValue,
              groupValue: currentValue,
              title: const Text('All Stages'),
              onChanged: (value) => Navigator.pop(context, value),
            ),
            for (final stage in ConnectionStage.values)
              RadioListTile<String>(
                value: stage,
                groupValue: currentValue,
                activeColor: ConnectionStage.color(stage),
                title: Text(ConnectionStage.label(stage)),
                onChanged: (value) => Navigator.pop(context, value),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasAnyData;
  final VoidCallback onAddConnection;

  const _EmptyState({
    required this.hasAnyData,
    required this.onAddConnection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 54),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: AppPallete.salesPrimarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.link_rounded,
              color: AppPallete.salesPrimary,
              size: 25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasAnyData ? 'No matching connections found' : 'No connections yet',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasAnyData
                ? 'Try changing the search query or selected stage.'
                : 'Create your first connection to start building the sales pipeline.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppPallete.textSecondary,
            ),
          ),
          if (!hasAnyData) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAddConnection,
              style: FilledButton.styleFrom(
                backgroundColor: AppPallete.salesPrimary,
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Connection'),
            ),
          ],
        ],
      ),
    );
  }
}
