import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/delete_connection_dialog.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/edit_connection_form.dart';

class ConnectionListItem extends StatelessWidget {
  final String clientId;
  final ConnectionEntity connection;

  const ConnectionListItem({
    super.key,
    required this.clientId,
    required this.connection,
  });

  void _openEditForm(BuildContext context) {
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
          child: EditConnectionForm(clientId: clientId, connection: connection),
        );
      },
    );
  }

  void _delete(BuildContext context) {
    showDeleteConnectionDialog(
      context: context,
      connectionId: connection.id!,
      clientId: clientId,
    );
  }

  Future<void> _changeStage(BuildContext context) async {
    final bloc = context.read<ConnectionBloc>();
    final currentStage = connection.stage;

    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  'Change Stage',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              for (final stage in ConnectionStage.values)
                RadioListTile<String>(
                  value: stage,
                  groupValue: currentStage,
                  activeColor: ConnectionStage.color(stage),
                  title: Text(ConnectionStage.label(stage)),
                  onChanged: (value) => Navigator.pop(sheetContext, value),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected == null || selected == currentStage || connection.id == null) {
      return;
    }

    bloc.add(
      UpdateConnectionStageSubmitted(
        id: connection.id!,
        clientId: clientId,
        stage: selected,
      ),
    );
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final period = local.hour >= 12 ? 'PM' : 'AM';
    final minute = local.minute.toString().padLeft(2, '0');

    return '${_months[local.month - 1]} ${local.day}, ${local.year} · $hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final stageColor = ConnectionStage.color(connection.stage);
    final stageLabel = ConnectionStage.label(connection.stage);

    final subtitleParts = <String>[
      if (connection.channelName != null) connection.channelName!,
      if (connection.assigneeName != null || connection.assigneeId != null)
        'Assignee: ${connection.assigneeName ?? connection.assigneeId}',
      if (connection.initiatedBy != null)
        'Initiated by: ${InitiatedBy.label(connection.initiatedBy!)}',
    ];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: stageColor.withOpacity(0.15),
        child: Icon(Icons.hub_outlined, color: stageColor),
      ),

      title: Row(
        children: [
          Expanded(
            child: Text(
              connection.productName ?? 'Product #${connection.productId}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _changeStage(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: stageColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stageLabel,
                    style: TextStyle(
                      color: stageColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.keyboard_arrow_down, size: 14, color: stageColor),
                ],
              ),
            ),
          ),
        ],
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitleParts.isNotEmpty)
            Text(
              subtitleParts.join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (connection.createdAt != null)
            Text(
              _formatDate(connection.createdAt!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),

      isThreeLine: subtitleParts.isNotEmpty && connection.createdAt != null,

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _openEditForm(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context),
          ),
        ],
      ),
    );
  }
}
