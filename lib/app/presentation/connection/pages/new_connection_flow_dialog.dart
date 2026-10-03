import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_bloc.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_event.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_state.dart';
import 'package:optima_sync_v2/app/presentation/client/pages/client_form.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/connection_form.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class NewConnectionFlowDialog extends StatefulWidget {
  const NewConnectionFlowDialog({super.key});

  @override
  State<NewConnectionFlowDialog> createState() =>
      _NewConnectionFlowDialogState();
}

class _NewConnectionFlowDialogState extends State<NewConnectionFlowDialog> {
  final _searchController = TextEditingController();

  int _step = 1;
  bool _selectExisting = true;
  ClientEntity? _selectedClient;

  @override
  void initState() {
    super.initState();
    context.read<ClientBloc>().add(
      const LoadClients(filter: ClientFilter(perPage: 100, page: 1)),
    );
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToConnectionStep() {
    if (_selectedClient?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client first')),
      );
      return;
    }

    setState(() => _step = 2);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.84;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: SizedBox(
          height: height,
          child: Column(
            children: [
              _DialogHeader(
                step: _step,
                onClose: () => Navigator.pop(context, false),
              ),
              const Divider(height: 1, color: AppPallete.cardBorder),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _step == 1
                      ? _buildClientStep()
                      : _buildConnectionStep(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientStep() {
    return Column(
      key: const ValueKey('client-step'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppPallete.inputFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SegmentButton(
                    selected: _selectExisting,
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Select Existing',
                    onTap: () => setState(() => _selectExisting = true),
                  ),
                ),
                Expanded(
                  child: _SegmentButton(
                    selected: !_selectExisting,
                    icon: Icons.add_circle_outline_rounded,
                    label: 'New Client',
                    onTap: () => setState(() => _selectExisting = false),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: _selectExisting
              ? _buildExistingClients()
              : _buildNewClientForm(),
        ),
        if (_selectExisting)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _selectedClient == null
                      ? null
                      : _goToConnectionStep,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppPallete.salesPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  label: const Text('Next'),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildExistingClients() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search client by name...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _searchController.clear,
                      icon: const Icon(Icons.close_rounded, size: 18),
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: AppPallete.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: AppPallete.salesPrimary),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: const BoxDecoration(
              color: AppPallete.inputFill,
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: const Row(
              children: [
                SizedBox(width: 34, child: Text('Select', style: _tableHeader)),
                SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text('Client Name', style: _tableHeader),
                ),
                Expanded(flex: 2, child: Text('Type', style: _tableHeader)),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientInitial || state is ClientLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ClientFailure &&
                    (state.clients?.isEmpty ?? true)) {
                  return _MessageState(
                    icon: Icons.cloud_off_outlined,
                    message: state.message,
                    actionLabel: 'Retry',
                    onAction: () => context.read<ClientBloc>().add(
                      const LoadClients(
                        filter: ClientFilter(perPage: 100, page: 1),
                      ),
                    ),
                  );
                }

                final clients = switch (state) {
                  ClientSuccess(:final clients) => clients,
                  ClientSubmitting(:final clients) => clients,
                  ClientFailure(:final clients) =>
                    clients ?? const <ClientEntity>[],
                  _ => const <ClientEntity>[],
                };

                final query = _searchController.text.trim().toLowerCase();
                final filtered = clients
                    .where(
                      (client) =>
                          query.isEmpty ||
                          client.name.toLowerCase().contains(query) ||
                          client.phone.toLowerCase().contains(query),
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return const _MessageState(
                    icon: Icons.person_search_outlined,
                    message: 'No clients found',
                  );
                }

                final hasMore = state is ClientSuccess && state.hasMore;
                final isLoadingMore =
                    state is ClientSuccess && state.isLoadingMore;

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: filtered.length + (hasMore ? 1 : 0),
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppPallete.cardBorder),
                  itemBuilder: (context, index) {
                    if (index == filtered.length) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: TextButton(
                            onPressed: isLoadingMore
                                ? null
                                : () => context.read<ClientBloc>().add(
                                    LoadMoreClients(),
                                  ),
                            child: isLoadingMore
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Load more'),
                          ),
                        ),
                      );
                    }

                    final client = filtered[index];
                    final selected = _selectedClient?.id == client.id;

                    return InkWell(
                      onTap: () => setState(() => _selectedClient = client),
                      child: Container(
                        color: selected
                            ? AppPallete.salesPrimarySoft
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 34,
                              child: Radio<String?>(
                                value: client.id,
                                groupValue: _selectedClient?.id,
                                activeColor: AppPallete.salesPrimary,
                                onChanged: (_) =>
                                    setState(() => _selectedClient = client),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: Text(
                                client.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                _clientTypeLabel(client.clientType),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppPallete.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewClientForm() {
    return ClientForm(
      title: 'New Client',
      submitLabel: 'Create Client & Continue',
      closeOnSuccess: false,
      onCreated: (client) {
        if (client.id == null) return;
        setState(() {
          _selectedClient = client;
          _step = 2;
        });
      },
      onSubmit: (client) {
        context.read<ClientBloc>().add(AddClientSubmitted(client: client));
      },
    );
  }

  Widget _buildConnectionStep() {
    final selectedClient = _selectedClient;
    if (selectedClient?.id == null) {
      return const SizedBox.shrink();
    }

    return Column(
      key: const ValueKey('connection-step'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => setState(() => _step = 1),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppPallete.salesPrimarySoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 18,
                        color: AppPallete.salesPrimary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedClient!.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ConnectionForm(
            title: 'Connection Details',
            submitLabel: 'Create Connection',
            closeOnSuccess: false,
            onSuccess: () {
              if (mounted) Navigator.pop(context, true);
            },
            onSubmit: (connection) {
              context.read<ConnectionBloc>().add(
                AddConnectionSubmitted(
                  clientId: selectedClient.id!,
                  connection: connection,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

const _tableHeader = TextStyle(
  fontSize: 10.5,
  fontWeight: FontWeight.w700,
  color: Color(0xFF5F6878),
);

class _DialogHeader extends StatelessWidget {
  final int step;
  final VoidCallback onClose;

  const _DialogHeader({required this.step, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppPallete.salesPrimarySoft,
              borderRadius: BorderRadius.circular(12),
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
                  'New Connection',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2),
                Text(
                  'Select or create a client',
                  style: TextStyle(
                    color: AppPallete.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          _StepPill(label: 'Step 1', selected: step == 1),
          const SizedBox(width: 4),
          _StepPill(label: 'Step 2', selected: step == 2),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded)),
        ],
      ),
    );
  }
}

class _StepPill extends StatelessWidget {
  final String label;
  final bool selected;

  const _StepPill({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? AppPallete.salesPrimary : AppPallete.inputFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppPallete.textSecondary,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: AppPallete.cardBorder) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? AppPallete.textPrimary
                  : AppPallete.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppPallete.textPrimary
                    : AppPallete.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 38, color: AppPallete.textSecondary),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppPallete.textSecondary),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 10),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

String _clientTypeLabel(String value) {
  if (value.isEmpty) return '—';
  return '${value[0].toUpperCase()}${value.substring(1)}';
}
