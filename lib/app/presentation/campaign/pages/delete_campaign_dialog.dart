import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_bloc.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_event.dart';
import 'package:optima_sync_v2/app/presentation/campaign/bloc/campaign_state.dart';

Future<bool?> showDeleteCampaignDialog({
  required BuildContext context,
  required String campaignId,
  required String campaignName,
}) {
  final bloc = context.read<CampaignBloc>();

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: BlocListener<CampaignBloc, CampaignState>(
          listener: (context, state) {
            if (state is CampaignSuccess) {
              Navigator.pop(dialogContext, true);
            }

            if (state is CampaignFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<CampaignBloc, CampaignState>(
            builder: (context, state) {
              final isDeleting = state is CampaignLoading;

              return AlertDialog(
                title: const Text("Delete Campaign"),

                content: Text(
                  'Are you sure you want to delete "$campaignName"? '
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
                              DeleteCampaignSubmitted(id: campaignId),
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
