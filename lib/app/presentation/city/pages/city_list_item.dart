import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/delete_city_dialog.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/edit_city_form.dart';

class CityListItem extends StatelessWidget {
  final CityEntity city;

  const CityListItem({super.key, required this.city});

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

  void _openEditCityForm(BuildContext context) {
    final bloc = context.read<CityBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: EditCityForm(city: city),
        );
      },
    );
  }

  void _deleteCity(BuildContext context) {
    showDeleteCityDialog(context: context, cityId: city.id!);
  }

  @override
  Widget build(BuildContext context) {
    final cityColor = _hexToColor(city.color);

    return ListTile(
      leading: Icon(Icons.location_city_outlined, color: cityColor),

      title: Text(city.name),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              _openEditCityForm(context);
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _deleteCity(context);
            },
          ),
        ],
      ),
    );
  }
}
