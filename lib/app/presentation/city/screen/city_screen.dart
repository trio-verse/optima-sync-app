import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/add_city_form.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/city_list_item.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class CityScreen extends StatefulWidget {
  final bool embedded;

  const CityScreen({super.key, this.embedded = false});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();

    context.read<CityBloc>().add(LoadCities());

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

  void _openAddCityForm() {
    final bloc = context.read<CityBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPallete.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider.value(value: bloc, child: const AddCityForm());
      },
    );
  }

  List<CityEntity> _filter(List<CityEntity> cities) {
    if (_query.isEmpty) return cities;

    return cities
        .where((city) => city.name.toLowerCase().contains(_query))
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
              title: const Text("Cities"),
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddCityForm,
        backgroundColor: AppPallete.industryPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          "Add City",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: BlocBuilder<CityBloc, CityState>(
        builder: (context, state) {
          if (state is CityInitial || state is CityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CityFailure && state.cities == null) {
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
                        context.read<CityBloc>().add(LoadCities());
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          List<CityEntity> cities = const [];

          if (state is CitySuccess) {
            cities = state.cities;
          } else if (state is CityFailure && state.cities != null) {
            cities = state.cities!;
          }

          final filtered = _filter(cities);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CityBloc>().add(LoadCities());
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                const _CitiesHeaderCard(),
                const SizedBox(height: 12),
                _SearchCard(controller: searchController, query: _query),
                const SizedBox(height: 14),
                if (state is CityFailure)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      state.message,
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                if (cities.isEmpty)
                  const _EmptyState(hasAnyData: false)
                else if (filtered.isEmpty)
                  const _EmptyState(hasAnyData: true)
                else
                  for (final city in filtered)
                    CityListItem(key: ValueKey(city.id), city: city),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CitiesHeaderCard extends StatelessWidget {
  const _CitiesHeaderCard();

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
              Icons.location_on_outlined,
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
                  'Cities Management',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: AppPallete.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add and manage cities to filter users across the dashboard.',
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

  const _SearchCard({required this.controller, required this.query});

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
        style: const TextStyle(fontSize: 14, color: AppPallete.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search cities...',
          hintStyle: const TextStyle(
            color: AppPallete.textSecondary,
            fontSize: 13.5,
          ),
          prefixIcon: const Icon(Icons.search, color: AppPallete.textSecondary),
          suffixIcon: query.isEmpty
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
              Icons.location_on_outlined,
              color: AppPallete.placeholderIcon,
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasAnyData ? 'No matching cities' : 'No cities yet',
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
                : 'Cities you add will show up here',
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
