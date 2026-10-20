import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/marketing/content_entity.dart';
import 'package:optima_sync_v2/app/presentation/marketing/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/marketing/content/pages/add_content_form.dart';
import 'package:optima_sync_v2/app/presentation/marketing/content/pages/content_card.dart';

class ContentKanbanScreen extends StatefulWidget {
  final String campaignId;
  final String campaignName;

  final List<String>? campaignChannelIds;

  const ContentKanbanScreen({super.key, required this.campaignId, required this.campaignName, this.campaignChannelIds});

  @override
  State<ContentKanbanScreen> createState() => _ContentKanbanScreenState();
}

class _ContentKanbanScreenState extends State<ContentKanbanScreen> {
  String _selectedStatus = ContentStatus.values.first;
  @override
  void initState() {
    super.initState();
    context.read<ContentBloc>().add(ContentEvent.getAllCampaignContents(campaignId: widget.campaignId));
  }

  void _openAddContentForm() {
    final bloc = context.read<ContentBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: AddContentForm(campaignId: widget.campaignId, campaignChannelIds: widget.campaignChannelIds),
        );
      },
    );
  }

  void _moveToStatus(ContentEntity content, String newStatus) {
    if (content.status == newStatus) return;

    context.read<ContentBloc>().add(ContentEvent.updateCampaignContent(content: content.copyWith(status: newStatus)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.campaignName} · Content')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddContentForm,
        icon: const Icon(Icons.add),
        label: const Text("New Content"),
      ),

      body: BlocConsumer<ContentBloc, ContentState>(
        listener: (context, state) {
          if (state is ContentSuccess && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!)));
          }

          if (state is ContentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          if (state is ContentInitial || state is ContentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ContentFailure && state.contents == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ContentBloc>().add(LoadContents(campaignId: widget.campaignId));
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          final contents = switch (state) {
            ContentSuccess(:final contents) => contents,
            ContentSubmitting(:final contents) => contents,
            ContentFailure(:final contents) => contents ?? const [],
            _ => const <ContentEntity>[],
          };

          if (contents.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.view_kanban_outlined, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text("No content yet"),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _openAddContentForm,
                      icon: const Icon(Icons.add),
                      label: const Text("New Content"),
                    ),
                  ],
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < AppPallete.mobileBreakpoint) {
                final visible = contents.where((content) => content.status == _selectedStatus).toList();
                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        children: ContentStatus.values
                            .map(
                              (status) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(
                                    '${ContentStatus.label(status)} (${contents.where((content) => content.status == status).length})',
                                  ),
                                  selected: _selectedStatus == status,
                                  selectedColor: AppPallete.primarySoft,
                                  onSelected: (_) => setState(() => _selectedStatus = status),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    if (state is ContentSubmitting) const LinearProgressIndicator(minHeight: 2),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                        children: [
                          if (visible.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Text('No content in this status.', textAlign: TextAlign.center),
                            ),
                          ...visible.map(
                            (content) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ContentCard(
                                  campaignId: widget.campaignId,
                                  content: content,
                                  campaignChannelIds: widget.campaignChannelIds,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: PopupMenuButton<String>(
                                    tooltip: 'Change status',
                                    onSelected: (status) => _moveToStatus(content, status),
                                    itemBuilder: (_) => ContentStatus.values
                                        .map(
                                          (status) =>
                                              PopupMenuItem(value: status, child: Text(ContentStatus.label(status))),
                                        )
                                        .toList(),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'Change status',
                                        style: TextStyle(color: AppPallete.primary, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ContentStatus.values.map((status) {
                    final columnItems = contents.where((c) => c.status == status).toList();

                    return _KanbanColumn(
                      status: status,
                      items: columnItems,
                      campaignId: widget.campaignId,
                      campaignChannelIds: widget.campaignChannelIds,
                      onDropped: (content) => _moveToStatus(content, status),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final String status;
  final List<ContentEntity> items;
  final String campaignId;
  final List<String>? campaignChannelIds;
  final void Function(ContentEntity content) onDropped;

  const _KanbanColumn({
    required this.status,
    required this.items,
    required this.campaignId,
    required this.campaignChannelIds,
    required this.onDropped,
  });

  @override
  Widget build(BuildContext context) {
    final color = ContentStatus.color(status);

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 280,
        child: DragTarget<ContentEntity>(
          onWillAcceptWithDetails: (details) => details.data.status != status,
          onAcceptWithDetails: (details) => onDropped(details.data),
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;

            return Container(
              decoration: BoxDecoration(
                color: isHovering ? color.withOpacity(0.08) : AppPallete.inputFill,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isHovering ? color : AppPallete.cardBorder, width: isHovering ? 2 : 1),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(ContentStatus.icon(status), size: 16, color: color),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          ContentStatus.label(status),
                          style: TextStyle(fontWeight: FontWeight.w700, color: color),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${items.length}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 560),
                    child: items.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Drop content here',
                              style: TextStyle(fontSize: 12, color: AppPallete.textSecondary),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: items.map((content) {
                                return LongPressDraggable<ContentEntity>(
                                  data: content,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: 260,
                                      child: ContentCard(
                                        campaignId: campaignId,
                                        content: content,
                                        campaignChannelIds: campaignChannelIds,
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.3,
                                    child: ContentCard(
                                      campaignId: campaignId,
                                      content: content,
                                      campaignChannelIds: campaignChannelIds,
                                    ),
                                  ),
                                  child: ContentCard(
                                    campaignId: campaignId,
                                    content: content,
                                    campaignChannelIds: campaignChannelIds,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
