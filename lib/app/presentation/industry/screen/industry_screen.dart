import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_event.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_state.dart';
import 'package:optima_sync_v2/app/presentation/industry/pages/add_industry_form.dart';
import 'package:optima_sync_v2/app/presentation/industry/pages/industry_list_item.dart';

class IndustryScreen extends StatefulWidget {
  const IndustryScreen({super.key});

  @override
  State<IndustryScreen> createState() => _IndustryScreenState();
}

class _IndustryScreenState extends State<IndustryScreen> {
  final searchController = TextEditingController();
  String _query = '';

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
      appBar: AppBar(title: const Text("Industries")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddIndustryForm,
        icon: const Icon(Icons.add),
        label: const Text("Add Industry"),
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
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
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
          }

          final filtered = _filter(industries);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search industries...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                            },
                          ),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: industries.isEmpty
                    ? const Center(child: Text("No industries yet"))
                    : filtered.isEmpty
                    ? const Center(child: Text("No matching industries"))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return IndustryListItem(industry: filtered[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
