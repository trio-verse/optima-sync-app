import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/City/pages/add_city_form.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/city_list_item.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  @override
  void initState() {
    super.initState();

    context.read<CityBloc>().add(LoadCities());
  }

  void _openAddCityForm() {
    final bloc = context.read<CityBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(value: bloc, child: const AddCityForm());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cities")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddCityForm,
        icon: const Icon(Icons.add),
        label: const Text("Add City"),
      ),

      body: BlocBuilder<CityBloc, CityState>(
        builder: (context, state) {
          if (state is CityInitial || state is CityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CityFailure) {
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
                        context.read<CityBloc>().add(LoadCities());
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CitySuccess) {
            if (state.cities.isEmpty) {
              return const Center(child: Text("No cities yet"));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.cities.length,
              separatorBuilder: (_, __) {
                return const Divider(height: 1);
              },
              itemBuilder: (context, index) {
                return CityListItem(city: state.cities[index]);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
