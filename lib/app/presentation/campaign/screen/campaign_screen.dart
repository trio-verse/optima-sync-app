import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/campaign_entity.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_bloc.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_event.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_state.dart';
import 'package:optima_sync_v2/app/presentation/campaign/pages/add_campaign_form.dart';
import 'package:optima_sync_v2/app/presentation/campaign/pages/campaign_list_item.dart';
import 'package:optima_sync_v2/app/presentation/campaign/pages/delete_campaign_dialog.dart';
import 'package:optima_sync_v2/app/presentation/campaign/pages/edit_campaign_form.dart';
import 'package:optima_sync_v2/app/presentation/campaign/screen/campaign_detail_screen.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  String? statusFilter;
  String sortBy = 'cpl';

  @override
  void initState() {
    super.initState();
    context.read<CampaignBloc>().add(LoadCampaigns());
  }

  void _openAddCampaignForm() {
    final bloc = context.read<CampaignBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          BlocProvider.value(value: bloc, child: const AddCampaignForm()),
    );
  }

  void _openEditCampaignForm(CampaignEntity campaign) {
    final bloc = context.read<CampaignBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: EditCampaignForm(campaign: campaign),
      ),
    );
  }

  List<CampaignEntity> _visibleCampaigns(List<CampaignEntity> source) {
    final filtered = source
        .where(
          (campaign) => statusFilter == null || campaign.status == statusFilter,
        )
        .toList();

    double cpl(CampaignEntity c) => c.cpl ?? double.infinity;
    switch (sortBy) {
      case 'name':
        filtered.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case 'budget':
        filtered.sort(
          (a, b) => (a.expectedBudget ?? 0).compareTo(b.expectedBudget ?? 0),
        );
        break;
      case 'spent':
        filtered.sort((a, b) => (a.spent ?? 0).compareTo(b.spent ?? 0));
        break;
      case 'cpl':
      default:
        filtered.sort((a, b) => cpl(a).compareTo(cpl(b)));
        break;
    }
    return filtered;
  }

  String _sortLabel() {
    switch (sortBy) {
      case 'name':
        return 'Sort by: Name';
      case 'budget':
        return 'Sort by: Budget';
      case 'spent':
        return 'Sort by: Spent';
      default:
        return 'Sort by: Lowest CPL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Marketing Campaigns',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppPallete.salesPrimary,
        foregroundColor: Colors.white,
        onPressed: _openAddCampaignForm,
        icon: const Icon(Icons.add),
        label: const Text('New Campaign'),
      ),
      body: BlocConsumer<CampaignBloc, CampaignState>(
        listener: (context, state) {
          if (state is CampaignFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CampaignInitial || state is CampaignLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CampaignFailure && state.campaigns == null) {
            return _CampaignError(
              message: state.message,
              onRetry: () => context.read<CampaignBloc>().add(LoadCampaigns()),
            );
          }

          final all = switch (state) {
            CampaignSuccess(:final campaigns) => campaigns,
            CampaignFailure(:final campaigns) =>
              campaigns ?? const <CampaignEntity>[],
            _ => const <CampaignEntity>[],
          };
          final visible = _visibleCampaigns(all);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CampaignBloc>().add(LoadCampaigns());
              await context.read<CampaignBloc>().stream.firstWhere(
                (next) => next is CampaignSuccess || next is CampaignFailure,
              );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              children: [
                const Text(
                  'Track campaign budgets, CPL, and deal ROI.',
                  style: TextStyle(color: AppPallete.textSecondary),
                ),
                const SizedBox(height: 14),
                _FilterBar(
                  selected: statusFilter,
                  onChanged: (value) => setState(() => statusFilter = value),
                  sortLabel: _sortLabel(),
                  onSort: _showSortMenu,
                ),
                const SizedBox(height: 16),
                if (visible.isEmpty)
                  _EmptyCampaigns(isFiltered: all.isNotEmpty)
                else
                  ...visible.map(
                    (campaign) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CampaignListItem(
                        campaign: campaign,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<CampaignBloc>(),
                              child: CampaignDetailScreen(campaign: campaign),
                            ),
                          ),
                        ),
                        onEdit: () => _openEditCampaignForm(campaign),
                        onDelete: () => showDeleteCampaignDialog(
                          context: context,
                          campaignId: campaign.id!,
                          campaignName: campaign.name,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showSortMenu() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Sort campaigns',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            _SortTile(value: 'cpl', label: 'Lowest CPL'),
            _SortTile(value: 'name', label: 'Name'),
            _SortTile(value: 'budget', label: 'Budget'),
            _SortTile(value: 'spent', label: 'Spent'),
          ],
        ),
      ),
    );

    if (selected != null) setState(() => sortBy = selected);
  }
}

class _SortTile extends StatelessWidget {
  final String value;
  final String label;

  const _SortTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.sort_rounded),
      title: Text(label),
      onTap: () => Navigator.pop(context, value),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  final String sortLabel;
  final VoidCallback onSort;

  const _FilterBar({
    required this.selected,
    required this.onChanged,
    required this.sortLabel,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final labels = <String?, String>{
      null: 'All',
      'active': 'Active',
      'draft': 'Draft',
      'paused': 'Paused',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: labels.length,
            separatorBuilder: (_, __) => const SizedBox(width: 7),
            itemBuilder: (_, index) {
              final entry = labels.entries.elementAt(index);
              final isSelected = selected == entry.key;
              return ChoiceChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (_) => onChanged(entry.key),
                selectedColor: AppPallete.salesPrimary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppPallete.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? AppPallete.salesPrimary
                      : AppPallete.cardBorder,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onSort,
          icon: const Icon(Icons.swap_vert_rounded, size: 18),
          label: Text(sortLabel),
        ),
      ],
    );
  }
}

class _EmptyCampaigns extends StatelessWidget {
  final bool isFiltered;

  const _EmptyCampaigns({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.campaign_outlined,
            size: 44,
            color: AppPallete.placeholderIcon,
          ),
          const SizedBox(height: 12),
          Text(
            isFiltered ? 'No campaigns match your filters' : 'No campaigns yet',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          const Text(
            'Create a campaign to start tracking marketing performance.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppPallete.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _CampaignError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CampaignError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
