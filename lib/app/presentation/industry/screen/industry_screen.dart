import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_event.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_state.dart';
import 'package:optima_sync_v2/app/presentation/industry/pages/add_industry_form.dart';
import 'package:optima_sync_v2/app/presentation/industry/pages/industry_list_item.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class IndustryScreen extends StatefulWidget {
  final bool embedded;

  const IndustryScreen({super.key, this.embedded = false});

  @override
  State<IndustryScreen> createState() => _IndustryScreenState();
}

class _IndustryScreenState extends State<IndustryScreen> {
  final searchController = TextEditingController();
  String _query = '';

  String? _editingIndustryId;

  @override
  void initState() {
    super.initState();

    context.read<IndustryBloc>().add(LoadIndustries());

    searchController.addListener(() {
      setState(() {
        _query = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _openAddIndustryForm() {
    final bloc = context.read<IndustryBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPallete.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider.value(value: bloc, child: const AddIndustryForm());
      },
    );
  }

  List<IndustryEntity> _filter(List<IndustryEntity> industries) {
    if (_query.isEmpty) return industries;

    return industries
        .where((industry) => industry.name.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.pageBackground,
      appBar: widget.embedded
          ? null
          : AppBar(
              backgroundColor: AppPallete.pageBackground,
              surfaceTintColor: AppPallete.pageBackground,
              elevation: 0,
              foregroundColor: AppPallete.textPrimary,
              title: const Text('Industries'),
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddIndustryForm,
        backgroundColor: AppPallete.industryPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add Industry",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: BlocBuilder<IndustryBloc, IndustryState>(
        builder: (context, state) {
          if (state is IndustryInitial || state is IndustryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is IndustryFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppPallete.textPrimary),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.industryPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.read<IndustryBloc>().add(LoadIndustries());
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          List<IndustryEntity> industries = const [];

          if (state is IndustrySuccess) {
            industries = state.industries;
          } else if (state is IndustryAdding) {
            industries = state.industries;
          } else if (state is IndustryAddFailure) {
            industries = state.industries;
          } else if (state is IndustryUpdating) {
            industries = state.industries;
          } else if (state is IndustryDeleting) {
            industries = state.industries;
          }

          final filtered = _filter(industries);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<IndustryBloc>().add(LoadIndustries());
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                const _IndustriesHeaderCard(),
                const SizedBox(height: 12),
                _SearchCard(
                  controller: searchController,
                  query: _query,
                  enabled: _editingIndustryId == null,
                ),
                const SizedBox(height: 14),
                if (industries.isEmpty)
                  const _EmptyState(hasAnyData: false)
                else if (filtered.isEmpty)
                  const _EmptyState(hasAnyData: true)
                else
                  for (final industry in filtered)
                    IndustryListItem(
                      key: ValueKey(industry.id),
                      industry: industry,
                      activeEditingId: _editingIndustryId,
                      onEditingChanged: (id) {
                        setState(() => _editingIndustryId = id);
                      },
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _IndustriesHeaderCard extends StatelessWidget {
  const _IndustriesHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppPallete.industryPrimarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: AppPallete.industryPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Industries & Specializations',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: AppPallete.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage and organize the industries available in your system.',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppPallete.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final bool enabled;

  const _SearchCard({
    required this.controller,
    required this.query,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(fontSize: 14, color: AppPallete.textPrimary),
        decoration: InputDecoration(
          hintText: enabled
              ? 'Search industries...'
              : 'Finish editing to search...',
          hintStyle: const TextStyle(
            color: AppPallete.textSecondary,
            fontSize: 13.5,
          ),
          prefixIcon: const Icon(Icons.search, color: AppPallete.textSecondary),
          suffixIcon: (query.isEmpty || !enabled)
              ? null
              : IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                    color: AppPallete.textSecondary,
                  ),
                  onPressed: controller.clear,
                ),
          filled: true,
          fillColor: AppPallete.inputFill,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasAnyData;

  const _EmptyState({required this.hasAnyData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppPallete.placeholderBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: AppPallete.placeholderIcon,
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasAnyData ? 'No matching industries' : 'No industries yet',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasAnyData
                ? 'Try a different search term'
                : 'Industries you add will show up here',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppPallete.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
