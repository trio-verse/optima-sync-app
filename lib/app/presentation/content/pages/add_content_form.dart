import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_event.dart';

import 'content_form.dart';

class AddContentForm extends StatelessWidget {
  final String campaignId;
  final List<String>? campaignChannelIds;

  const AddContentForm({
    super.key,
    required this.campaignId,
    this.campaignChannelIds,
  });

  @override
  Widget build(BuildContext context) {
    return ContentForm(
      title: "New Content",
      submitLabel: "Add",
      campaignChannelIds: campaignChannelIds,
      onSubmit: (content) {
        context.read<ContentBloc>().add(
          AddContentSubmitted(
            campaignId: campaignId,
            content: content.copyWith(campaignId: campaignId),
          ),
        );
      },
    );
  }
}
