import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_event.dart';
import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_state.dart';

void showDeleteConnectionDialog({
  required BuildContext context,
  required String connectionId,
  required String clientId,
}) {
  final bloc = context.read<ConnectionBloc>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: BlocListener<ConnectionBloc, ConnectionState>(
          listener: (context, state) {
            if (state is ConnectionSuccess) {
              Navigator.pop(dialogContext);
            }

            if (state is ConnectionFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<ConnectionBloc, ConnectionState>(
            builder: (context, state) {
              final isDeleting = state is ConnectionSubmitting;

              return AlertDialog(
                title: const Text("Delete Connection"),

                content: const Text(
                  "Are you sure you want to delete this connection?",
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
                            context.read<ConnectionBloc>().add(
                              DeleteConnectionSubmitted(
                                id: connectionId,
                                clientId: clientId,
                              ),
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
