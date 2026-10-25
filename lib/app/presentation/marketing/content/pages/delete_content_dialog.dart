import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';

import 'package:optima_sync_v2/app/presentation/marketing/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/marketing/marketing_messages.dart';

void showDeleteContentDialog({required BuildContext context, required ContentEntity content}) {
  final bloc = context.read<ContentBloc>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: BlocListener<ContentBloc, ContentState>(
          listener: (context, state) {
            state.whenOrNull(
              success: (_, __) => Navigator.pop(dialogContext),
              failure: (error) =>
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.text(context)))),
            );
          },
          child: BlocBuilder<ContentBloc, ContentState>(
            builder: (context, state) {
              final isDeleting = state.maybeWhen(loading: () => true, orElse: () => false);
              return AlertDialog(
                title: const Text("Delete Content"),

                content: Text(
                  'Are you sure you want to delete "${content.title}"? '
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
                            context.read<ContentBloc>().add(ContentEvent.deleteCampaignContent(content: content));
                          },
                    child: isDeleting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
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
