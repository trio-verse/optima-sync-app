import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_bloc.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_event.dart';
import 'package:optima_sync_v2/app/presentation/industry/bloc/industry_state.dart';

class ClientFilterSheet extends StatefulWidget {
  final ClientFilter initialFilter;

  const ClientFilterSheet({super.key, required this.initialFilter});

  @override
  State<ClientFilterSheet> createState() => _ClientFilterSheetState();
}

class _ClientFilterSheetState extends State<ClientFilterSheet> {
  late final TextEditingController nameController;
  String? clientType;
  int? industryId;
  int? cityId;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.initialFilter.name);
    clientType = widget.initialFilter.clientType;
    industryId = widget.initialFilter.industryId;
    cityId = widget.initialFilter.cityId;

    context.read<IndustryBloc>().add(LoadIndustries());
    context.read<CityBloc>().add(LoadCities());
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _apply() {
    Navigator.pop(
      context,
      widget.initialFilter.copyWith(
        name: nameController.text.trim(),
        clientType: clientType,
        clearClientType: clientType == null,
        industryId: industryId,
        clearIndustryId: industryId == null,
        cityId: cityId,
        clearCityId: cityId == null,
        page: 1,
      ),
    );
  }

  void _clear() {
    Navigator.pop(context, const ClientFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter Clients",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              label: Text("Name"),
              prefixIcon: Icon(Icons.search),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.blue),
              ),
            ),
          ),

          const SizedBox(height: 15),

          DropdownButtonFormField<String?>(
            value: clientType,
            decoration: const InputDecoration(
              label: Text("Client Type"),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.blue),
              ),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text("Any type")),
              ...kClientTypes.map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type[0].toUpperCase() + type.substring(1)),
                ),
              ),
            ],
            onChanged: (value) => setState(() => clientType = value),
          ),

          const SizedBox(height: 15),

          BlocBuilder<IndustryBloc, IndustryState>(
            builder: (context, state) {
              final industries = state is IndustrySuccess
                  ? state.industries
                  : const <IndustryEntity>[];

              final safeIndustryId =
                  industryId == null ||
                      industries.any(
                        (i) =>
                            i.id != null && int.tryParse(i.id!) == industryId,
                      )
                  ? industryId
                  : null;

              return DropdownButtonFormField<int?>(
                value: safeIndustryId,
                decoration: const InputDecoration(
                  label: Text("Industry"),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blue),
                  ),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text("Any industry"),
                  ),
                  ...industries
                      .where((i) => i.id != null)
                      .map(
                        (i) => DropdownMenuItem(
                          value: int.parse(i.id!),
                          child: Text(i.name),
                        ),
                      ),
                ],
                onChanged: (value) => setState(() => industryId = value),
              );
            },
          ),

          const SizedBox(height: 15),

          BlocBuilder<CityBloc, CityState>(
            builder: (context, state) {
              final cities = state is CitySuccess
                  ? state.cities
                  : const <CityEntity>[];

              final safeCityId =
                  cityId == null ||
                      cities.any(
                        (c) => c.id != null && int.tryParse(c.id!) == cityId,
                      )
                  ? cityId
                  : null;

              return DropdownButtonFormField<int?>(
                value: safeCityId,
                decoration: const InputDecoration(
                  label: Text("City"),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blue),
                  ),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text("Any city")),
                  ...cities
                      .where((c) => c.id != null)
                      .map(
                        (c) => DropdownMenuItem(
                          value: int.parse(c.id!),
                          child: Text(c.name),
                        ),
                      ),
                ],
                onChanged: (value) => setState(() => cityId = value),
              );
            },
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clear,
                  child: const Text("Clear"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _apply,
                  child: const Text("Apply"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
