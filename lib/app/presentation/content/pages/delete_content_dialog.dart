import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_event.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_state.dart';

void showDeleteContentDialog({
  required BuildContext context,
  required String contentId,
  required String campaignId,
  required String contentTitle,
}) {
  final bloc = context.read<ContentBloc>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: BlocListener<ContentBloc, ContentState>(
          listener: (context, state) {
            if (state is ContentSuccess) {
              Navigator.pop(dialogContext);
            }

            if (state is ContentFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<ContentBloc, ContentState>(
            builder: (context, state) {
              final isDeleting = state is ContentSubmitting;

              return AlertDialog(
                title: const Text("Delete Content"),

                content: Text(
                  'Are you sure you want to delete "$contentTitle"? '
                  'This action cannot be undone.',
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
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: isDeleting
                        ? null
                        : () {
                            context.read<ContentBloc>().add(
                              DeleteContentSubmitted(
                                id: contentId,
                                campaignId: campaignId,
                              ),
                            );
                          },
                    child: isDeleting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Delete"),
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
