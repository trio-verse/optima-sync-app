import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/delete_connection_dialog.dart';
import 'package:optima_sync_v2/app/presentation/connection/pages/edit_connection_form.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class ConnectionLogItem extends StatelessWidget {
  final ConnectionEntity connection;

  const ConnectionLogItem({super.key, required this.connection});

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
    final hour = hour12.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    final minute = local.minute.toString().padLeft(2, '0');

    return '${_months[local.month - 1]} ${local.day}, ${local.year}, $hour:$minute $period';
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

    if (selected == null || selected == currentStage) return;
    if (connection.id == null || connection.clientId == null) return;

    bloc.add(
      UpdateConnectionStageSubmitted(
        id: connection.id!,
        clientId: connection.clientId!,
        stage: selected,
      ),
    );
  }

  void _openEditForm(BuildContext context) {
    if (connection.clientId == null) return;

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
          child: EditConnectionForm(
            clientId: connection.clientId!,
            connection: connection,
          ),
        );
      },
    );
  }

  void _delete(BuildContext context) {
    if (connection.id == null || connection.clientId == null) return;

    showDeleteConnectionDialog(
      context: context,
      connectionId: connection.id!,
      clientId: connection.clientId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stageColor = ConnectionStage.color(connection.stage);
    final stageLabel = ConnectionStage.label(connection.stage);
    final canEdit = connection.id != null && connection.clientId != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppPallete.inputFill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  connection.clientName ??
                      'Client #${connection.clientId ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppPallete.textPrimary,
                  ),
                ),
              ),
              InkWell(
                onTap: canEdit ? () => _changeStage(context) : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: stageColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        stageLabel,
                        style: TextStyle(
                          color: stageColor,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (canEdit) ...[
                        const SizedBox(width: 2),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: stageColor,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              if (connection.stage == ConnectionStage.won &&
                  connection.effectiveValue != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.attach_money,
                        size: 14,
                        color: Colors.green,
                      ),
                      Text(
                        connection.effectiveValue!.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 15,
                          color: AppPallete.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          connection.productName ??
                              'Product #${connection.productId}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppPallete.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (connection.campaignName != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sell_outlined,
                            size: 15,
                            color: AppPallete.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            connection.campaignName!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppPallete.accent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (canEdit) ...[
                InkWell(
                  onTap: () => _openEditForm(context),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppPallete.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => _delete(context),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ],
          ),

          if (connection.assigneeName != null ||
              connection.assigneeId != null ||
              connection.initiatedBy != null) ...[
            const SizedBox(height: 6),
            Text(
              [
                if (connection.assigneeName != null ||
                    connection.assigneeId != null)
                  'Assignee: ${connection.assigneeName ?? connection.assigneeId}',
                if (connection.initiatedBy != null)
                  'Initiated by: ${InitiatedBy.label(connection.initiatedBy!)}',
              ].join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: AppPallete.textSecondary,
              ),
            ),
          ],

          if (connection.createdAt != null) ...[
            const SizedBox(height: 6),
            Text(
              _formatDate(connection.createdAt!),
              style: const TextStyle(
                fontSize: 11.5,
                color: AppPallete.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
