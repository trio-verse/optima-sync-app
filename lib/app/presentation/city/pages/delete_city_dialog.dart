import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/city/bloc/city_bloc.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_event.dart';
import 'package:optima_sync_v2/app/presentation/city/bloc/city_state.dart';

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
                title: const Text("Delete City"),

                content: const Text(
                  "Are you sure you want to delete this city?",
                ),

                actions: [
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () {
                            Navigator.pop(dialogContext);
                          },
                    child: const Text("Cancel"),
                  ),

                  TextButton(
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
                            child: CircularProgressIndicator(strokeWidth: 2),
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
