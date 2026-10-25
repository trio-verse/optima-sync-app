import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/marketing/campaign_entity.dart';
import 'package:optima_sync_v2/app/presentation/marketing/campaign/bloc/campaign_bloc.dart';
import 'package:optima_sync_v2/app/presentation/marketing/marketing_messages.dart';

Future<bool?> showDeleteCampaignDialog({
  required BuildContext context,
  required CampaignEntity campaign,
}) {
  final bloc = context.read<CampaignBloc>();

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: BlocListener<CampaignBloc, CampaignState>(
          listener: (context, state) {
            state.whenOrNull(
              success: (_, successType) => Navigator.pop(dialogContext, true),
              failure: (error) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error.text(context))));
              },
            );
          },
          child: BlocBuilder<CampaignBloc, CampaignState>(
            builder: (context, state) {
              final isDeleting = state.maybeWhen(
                submitting: (_) => true,
                orElse: () => false,
              );

              return AlertDialog(
                title: const Text("Delete Campaign"),

                content: Text(
                  'Are you sure you want to delete "${campaign.name}"? '
                  'This action cannot be undone.',
                ),

                actions: [
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () {
                            Navigator.pop(dialogContext, false);
                          },
                    child: const Text("Cancel"),
                  ),

                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: isDeleting
                        ? null
                        : () {
                            context.read<CampaignBloc>().add(
                              DeleteCampaignSubmitted(campaign: campaign),
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
