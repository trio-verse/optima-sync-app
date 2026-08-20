import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';

class ClientListItem extends StatelessWidget {
  final ClientEntity client;
  final VoidCallback? onEdit;
  final bool isLoading;

  const ClientListItem({
    super.key,
    required this.client,
    this.onEdit,
    this.isLoading = false,
  });

  IconData _iconForType(String type) {
    switch (type) {
      case 'individual':
        return Icons.person_outline;
      case 'government':
        return Icons.account_balance_outlined;
      case 'charity':
        return Icons.volunteer_activism_outlined;
      case 'agency':
        return Icons.groups_outlined;
      case 'company':
      default:
        return Icons.business_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[
      if (client.phone.isNotEmpty) client.phone,
      if (client.cityName != null) client.cityName!,
      if (client.industryName != null) client.industryName!,
    ];

    return ListTile(
      leading: CircleAvatar(child: Icon(_iconForType(client.clientType))),
      title: Text(client.name),
      subtitle: subtitleParts.isEmpty ? null : Text(subtitleParts.join(' · ')),
      trailing: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
      onTap: onEdit,
    );
  }
}
