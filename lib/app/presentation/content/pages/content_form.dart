import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_event.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_state.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_state.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/content_permissions.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/content_status_style.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/markdown_script_editor.dart';

const List<String> _suggestedContentTypes = [
  'post',
  'video',
  'story',
  'reel',
  'banner',
  'article',
  'email',
];

class ContentForm extends StatefulWidget {
  final String title;
  final String submitLabel;

  final List<String>? campaignChannelIds;

  final ContentEntity? initial;
  final void Function(ContentEntity content) onSubmit;

  const ContentForm({
    super.key,
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    this.campaignChannelIds,
    this.initial,
  });

  @override
  State<ContentForm> createState() => _ContentFormState();
}

class _ContentFormState extends State<ContentForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController typeController;
  late final TextEditingController scriptController;
  late final TextEditingController costController;
  late final TextEditingController descriptionController;

  String? channelId;
  String status = 'draft';
  DateTime? publishedAt;

  bool _submitAttempted = false;

  @override
  void initState() {
    super.initState();

    final initial = widget.initial;

    titleController = TextEditingController(text: initial?.title ?? '');
    typeController = TextEditingController(text: initial?.type ?? '');
    scriptController = TextEditingController(text: initial?.script ?? '');
    costController = TextEditingController(
      text: initial?.cost == null ? '' : initial!.cost!.toStringAsFixed(2),
    );
    descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );

    channelId = initial?.channelId;
    status = initial?.status ?? 'draft';
    publishedAt = initial?.publishedAt == null
        ? null
        : DateTime.tryParse(initial!.publishedAt!);

    context.read<ChannelBloc>().add(LoadChannels());
  }

  @override
  void dispose() {
    titleController.dispose();
    typeController.dispose();
    scriptController.dispose();
    costController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? errorText, Widget? icon}) {
    return InputDecoration(
      label: Text(label),
      errorText: errorText,
      prefixIcon: icon,
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.blue),
      ),
    );
  }

  Future<void> _pickPublishedAt() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: publishedAt ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(publishedAt ?? now),
    );
    if (time == null) return;

    setState(() {
      publishedAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    setState(() => _submitAttempted = true);

    final isFormValid = formKey.currentState?.validate() ?? true;

    if (channelId == null || !isFormValid) {
      return;
    }

    final costText = costController.text.trim();

    widget.onSubmit(
      ContentEntity(
        id: widget.initial?.id,
        campaignId: widget.initial?.campaignId ?? '',
        channelId: channelId!,
        title: titleController.text.trim(),
        type: typeController.text.trim(),
        script: scriptController.text.trim(),
        cost: costText.isEmpty ? null : double.tryParse(costText),
        status: status,
        publishedAt: publishedAt?.toIso8601String(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSeeCostBadge = currentUserCanApproveCost();

    final costIsConfirmed = status == 'approved' || status == 'published';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, contentState) {
          final isSubmitting = contentState is ContentSubmitting;
          final errorMessage = contentState is ContentFailure
              ? contentState.message
              : null;

          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (errorMessage != null) ...[
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                  ],

                  TextFormField(
                    controller: titleController,
                    autofocus: true,
                    enabled: !isSubmitting,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title cannot be empty";
                      }
                      if (value.trim().length > 255) {
                        return "Title must not exceed 255 characters";
                      }
                      return null;
                    },
                    decoration: _decoration(
                      "Title *",
                      icon: const Icon(Icons.title_outlined),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: typeController,
                    enabled: !isSubmitting,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Type cannot be empty";
                      }
                      if (value.trim().length > 255) {
                        return "Type must not exceed 255 characters";
                      }
                      return null;
                    },
                    decoration: _decoration(
                      "Type *",
                      icon: const Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _suggestedContentTypes.map((suggestion) {
                      return ActionChip(
                        label: Text(suggestion),
                        onPressed: isSubmitting
                            ? null
                            : () => setState(
                                () => typeController.text = suggestion,
                              ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: descriptionController,
                    enabled: !isSubmitting,
                    minLines: 2,
                    maxLines: 4,
                    decoration: _decoration(
                      "Description",
                      icon: const Icon(Icons.notes_outlined),
                    ),
                  ),

                  const SizedBox(height: 15),

                  MarkdownScriptEditor(
                    controller: scriptController,
                    enabled: !isSubmitting,
                    errorText:
                        _submitAttempted && scriptController.text.trim().isEmpty
                        ? "Script is required"
                        : null,
                  ),

                  const SizedBox(height: 15),

                  BlocBuilder<ChannelBloc, ChannelState>(
                    builder: (context, channelState) {
                      final allChannels = channelState is ChannelSuccess
                          ? channelState.channels
                          : const <ChannelEntity>[];

                      final channels = widget.campaignChannelIds == null
                          ? allChannels
                          : allChannels
                                .where(
                                  (c) =>
                                      widget.campaignChannelIds!.contains(c.id),
                                )
                                .toList();

                      final safeChannelId =
                          channels.any((c) => c.id == channelId)
                          ? channelId
                          : null;

                      return DropdownButtonFormField<String>(
                        value: safeChannelId,
                        decoration: _decoration(
                          "Channel *",
                          errorText: _submitAttempted && channelId == null
                              ? "Channel is required"
                              : null,
                          icon: const Icon(Icons.podcasts_outlined),
                        ),
                        hint: Text(
                          channelState is ChannelLoading
                              ? "Loading channels..."
                              : channels.isEmpty
                              ? "No channels available for this campaign"
                              : "Select a channel",
                        ),
                        items: channels
                            .where((c) => c.id != null)
                            .map(
                              (channel) => DropdownMenuItem(
                                value: channel.id,
                                child: Text(channel.name),
                              ),
                            )
                            .toList(),
                        onChanged: isSubmitting
                            ? null
                            : (value) => setState(() => channelId = value),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: _decoration(
                      "Status",
                      icon: const Icon(Icons.flag_outlined),
                    ),
                    items: kContentStatuses
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(ContentStatusStyle.label(s)),
                          ),
                        )
                        .toList(),
                    onChanged: isSubmitting
                        ? null
                        : (value) {
                            if (value != null) setState(() => status = value);
                          },
                  ),

                  const SizedBox(height: 15),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: costController,
                          enabled: !isSubmitting,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            final cost = double.tryParse(value.trim());
                            if (cost == null || cost < 0) {
                              return "Enter a valid cost";
                            }
                            return null;
                          },
                          decoration: _decoration(
                            "Cost (estimated)",
                            icon: const Icon(Icons.attach_money_outlined),
                          ),
                        ),
                      ),
                      if (canSeeCostBadge) ...[
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (costIsConfirmed
                                          ? Colors.green
                                          : Colors.orange)
                                      .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  costIsConfirmed
                                      ? Icons.check_circle_outline
                                      : Icons.hourglass_top_outlined,
                                  size: 14,
                                  color: costIsConfirmed
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  costIsConfirmed ? 'Confirmed' : 'Unconfirmed',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: costIsConfirmed
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 15),

                  OutlinedButton.icon(
                    onPressed: isSubmitting ? null : _pickPublishedAt,
                    icon: const Icon(Icons.event_available_outlined, size: 18),
                    label: Text(
                      publishedAt == null
                          ? 'Published At (optional)'
                          : publishedAt!.toLocal().toString(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      child: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.submitLabel),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
