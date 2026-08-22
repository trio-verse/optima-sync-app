import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';

class ChannelListItem extends StatelessWidget {
  final ChannelEntity channel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isLoading;

  const ChannelListItem({
    super.key,
    required this.channel,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
  });

  Color _hexToColor(String hex) {
    try {
      hex = hex.replaceFirst('#', '');

      if (hex.length == 6) {
        hex = 'FF$hex';
      }

      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelColor = _hexToColor(channel.color);

    return ListTile(
      leading: Icon(Icons.tag_outlined, color: channelColor),
      title: Text(channel.name),
      trailing: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit?.call();
                }

                if (value == 'delete') {
                  onDelete?.call();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
