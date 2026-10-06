import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_event.dart';

import 'content_form.dart';

class EditContentForm extends StatelessWidget {
  final String campaignId;
  final ContentEntity content;
  final List<String>? campaignChannelIds;

  const EditContentForm({
    super.key,
    required this.campaignId,
    required this.content,
    this.campaignChannelIds,
  });

  @override
  Widget build(BuildContext context) {
    return ContentForm(
      title: "Edit Content",
      submitLabel: "Save",
      initial: content,
      campaignChannelIds: campaignChannelIds,
      onSubmit: (updated) {
        context.read<ContentBloc>().add(
          UpdateContentSubmitted(
            id: content.id!,
            campaignId: campaignId,
            content: updated,
          ),
        );
      },
    );
  }
}
