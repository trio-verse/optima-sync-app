import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/delete_city_dialog.dart';
import 'package:optima_sync_v2/app/presentation/city/pages/edit_city_form.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

const List<Color> presetCityColors = [
  AppPallete.industryPrimary,
  Color(0xFF9333EA),
  Color(0xFFDB2777),
  Color(0xFFF59E0B),
  Color(0xFF16A34A),
  Color(0xFF0891B2),
  Color(0xFF475569),
];

String cityColorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

Color cityHexToColor(String hex) {
  try {
    hex = hex.replaceFirst('#', '');

    if (hex.length == 3) {
      hex = hex.split('').map((c) => '$c$c').join();
    }

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return AppPallete.industryPrimary;
  }
}

class CityListItem extends StatelessWidget {
  final CityEntity city;

  const CityListItem({super.key, required this.city});

  void _openEditCityForm(BuildContext context) {
    final bloc = context.read<CityBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPallete.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
    final cityColor = cityHexToColor(city.color);
    final initial = city.name.isNotEmpty ? city.name[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cityColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              city.name,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: AppPallete.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          _RoundIconButton(
            icon: Icons.edit_outlined,
            onTap: () => _openEditCityForm(context),
          ),
          const SizedBox(width: 8),
          _RoundIconButton(
            icon: Icons.delete_outline,
            iconColor: const Color(0xFFDC2626),
            onTap: () => _deleteCity(context),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _RoundIconButton({required this.icon, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppPallete.inputFill,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 17,
          color: iconColor ?? AppPallete.textSecondary,
        ),
      ),
    );
  }
}
