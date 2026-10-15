import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/connection/bloc/connection_bloc.dart';
import 'package:optima_sync_v2/app/presentation/connection/connection_messages.dart';

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
            state.whenOrNull(
              success: (_, __) {
                Navigator.pop(dialogContext);
              },
              failure: (error) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error.text(context))));
              },
            );
          },
          child: BlocBuilder<ConnectionBloc, ConnectionState>(
            builder: (context, state) {
              final isDeleting = state.maybeWhen(
                submitting: (_) => true,
                orElse: () => false,
              );
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
                              DeleteConnectionSubmitted(id: connectionId),
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
