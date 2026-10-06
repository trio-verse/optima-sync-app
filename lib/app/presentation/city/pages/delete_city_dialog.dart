import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

void showDeleteCityDialog({
  required BuildContext context,
  required String cityId,
}) {
  final bloc = context.read<CityBloc>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: BlocListener<CityBloc, CityState>(
          listener: (context, state) {
            if (state is CitySuccess) {
              Navigator.pop(dialogContext);
            }

            if (state is CityFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<CityBloc, CityState>(
            builder: (context, state) {
              final isDeleting = state is CityLoading;

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  "Delete City",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppPallete.textPrimary,
                  ),
                ),

                content: const Text(
                  "Are you sure you want to delete this city? This action cannot be undone.",
                  style: TextStyle(color: AppPallete.textSecondary),
                ),

                actions: [
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () {
                            Navigator.pop(dialogContext);
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: AppPallete.textSecondary,
                    ),
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isDeleting
                        ? null
                        : () {
                            context.read<CityBloc>().add(
                              DeleteCitySubmitted(id: cityId),
                            );
                          },
                    child: isDeleting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Confirm"),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
