import 'package:flutter/material.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/presentation/campaign/pages/campaign_status_style.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class CampaignListItem extends StatelessWidget {
  final CampaignEntity campaign;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isLoading;

  const CampaignListItem({
    super.key,
    required this.campaign,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
  });

  String _money(double? value) => value == null ? '—' : '\$${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final statusColor = CampaignStatusStyle.color(campaign.status);
    final initial = campaign.name.isNotEmpty ? campaign.name[0].toUpperCase() : '?';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppPallete.cardBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: AppPallete.salesPrimarySoft,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: AppPallete.salesPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            CampaignStatusStyle.label(campaign.status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              if (campaign.description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  campaign.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppPallete.textSecondary, fontSize: 12.5),
                ),
              ],
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 10,
                children: [
                  _Stat(label: 'Spent / Budget', value: '${_money(campaign.spent)} / ${_money(campaign.expectedBudget)}'),
                  _Stat(label: 'Connections', value: '${campaign.connections ?? 0}'),
                  _Stat(label: 'CPL', value: _money(campaign.cpl)),
                  _Stat(label: 'ROI', value: campaign.roi == null ? 'N/A' : '${campaign.roi!.toStringAsFixed(1)}%'),
                ],
              ),
              const Divider(height: 22),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Edit',
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: isLoading ? null : onEdit,
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: isLoading ? null : onDelete,
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: isLoading ? null : onTap,
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppPallete.textSecondary, fontSize: 10.5)),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
