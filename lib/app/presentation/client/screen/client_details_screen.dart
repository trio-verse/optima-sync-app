import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_bloc.dart';
import 'package:optima_sync_v2/app/presentation/client/bloc/client_state.dart';
import 'package:optima_sync_v2/app/presentation/client/pages/edit_client_form.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_state.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/add_connection_form.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/connection_list_item.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class ClientDetailsScreen extends StatefulWidget {
  final ClientEntity client;

  const ClientDetailsScreen({super.key, required this.client});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  late ClientEntity _client;

  String get _clientId => _client.id!;

  @override
  void initState() {
    super.initState();
    _client = widget.client;
    context.read<ConnectionBloc>().add(LoadConnections(clientId: _clientId));
  }

  void _openEditProfile() {
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
          child: EditClientForm(client: _client),
        );
      },
    );
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
      backgroundColor: AppPallete.pageBackground,
      appBar: AppBar(
        backgroundColor: AppPallete.pageBackground,
        surfaceTintColor: AppPallete.pageBackground,
        elevation: 0,
        foregroundColor: AppPallete.textPrimary,
        titleSpacing: 0,
        title: Text(
          _client.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppPallete.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: _openEditProfile,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),

      body: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientSuccess) {
            final updated = state.clients
                .where((c) => c.id == _client.id)
                .toList();

            if (updated.isNotEmpty) {
              setState(() => _client = updated.first);
            }
          }
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            _StakeholdersCard(),
            const SizedBox(height: 12),
            _ConnectionsLogCard(
              clientId: _clientId,
              onAddConnection: _openAddConnectionForm,
            ),
            const SizedBox(height: 12),
            _ClientTypeCard(clientType: _client.clientType),
            const SizedBox(height: 12),
            _ContactInfoCard(client: _client),
            const SizedBox(height: 12),
            _LocationFieldCard(client: _client),
            const SizedBox(height: 12),
            _NotesCard(notes: _client.notes),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Widget child;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppPallete.textPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppPallete.textPrimary,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppPallete.cardBorder),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF3559E0),
        backgroundColor: const Color(0xFFEDF0FE),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, color: AppPallete.textSecondary),
    );
  }
}

class _StakeholdersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      icon: Icons.groups_outlined,
      title: 'Stakeholders',
      trailing: _PillButton(
        icon: Icons.add,
        label: 'Add',

        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stakeholders are coming soon')),
          );
        },
      ),
      child: const _EmptyHint('No stakeholders added.'),
    );
  }
}

class _ConnectionsLogCard extends StatelessWidget {
  final String clientId;
  final VoidCallback onAddConnection;

  const _ConnectionsLogCard({
    required this.clientId,
    required this.onAddConnection,
  });

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      icon: Icons.link_rounded,
      title: 'Connections Log',
      trailing: _PillButton(
        icon: Icons.add,
        label: 'Add Connection',
        onPressed: onAddConnection,
      ),
      child: BlocBuilder<ConnectionBloc, ConnectionState>(
        builder: (context, state) {
          if (state is ConnectionInitial || state is ConnectionLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
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
            return const _EmptyHint(
              'No connections recorded yet for this client.',
            );
          }

          return Column(
            children: [
              for (var i = 0; i < connections.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                ConnectionListItem(
                  clientId: clientId,
                  connection: connections[i],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ClientTypeCard extends StatelessWidget {
  final String clientType;

  const _ClientTypeCard({required this.clientType});

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      icon: Icons.badge_outlined,
      title: 'Client Type',
      child: Row(
        children: [
          const Icon(
            Icons.badge_outlined,
            size: 16,
            color: AppPallete.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            clientType.isEmpty ? '—' : clientType,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppPallete.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? secondaryValue;

  const _LabeledValue({
    required this.icon,
    required this.label,
    required this.value,
    this.secondaryValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppPallete.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                    color: AppPallete.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppPallete.textPrimary,
                  ),
                ),
                if (secondaryValue != null && secondaryValue!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    secondaryValue!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppPallete.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  final ClientEntity client;

  const _ContactInfoCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      icon: Icons.contact_page_outlined,
      title: 'Contact Info',
      child: Column(
        children: [
          _LabeledValue(
            icon: Icons.call_outlined,
            label: 'Phone',
            value: client.phone.isEmpty ? '—' : client.phone,
          ),
          if (client.whatsapp != null && client.whatsapp!.isNotEmpty)
            _LabeledValue(
              icon: Icons.chat_bubble_outline,
              label: 'WhatsApp',
              value: client.whatsapp!,
            ),
          if (client.email != null && client.email!.isNotEmpty)
            _LabeledValue(
              icon: Icons.mail_outline,
              label: 'Email',
              value: client.email!,
            ),
        ],
      ),
    );
  }
}

class _LocationFieldCard extends StatelessWidget {
  final ClientEntity client;

  const _LocationFieldCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      icon: Icons.public_outlined,
      title: 'Location & Field',
      child: Column(
        children: [
          if (client.industryName != null && client.industryName!.isNotEmpty)
            _LabeledValue(
              icon: Icons.business_outlined,
              label: 'Industry',
              value: client.industryName!,
            ),
          _LabeledValue(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: client.cityName ?? (client.address ?? '—'),
            secondaryValue: client.cityName != null ? client.address : null,
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final String? notes;

  const _NotesCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      icon: Icons.description_outlined,
      title: 'Notes',
      child: Text(
        (notes == null || notes!.isEmpty) ? 'No notes added.' : notes!,
        style: const TextStyle(fontSize: 13.5, color: AppPallete.textPrimary),
      ),
    );
  }
}
