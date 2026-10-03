import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_bloc.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_event.dart';
import 'package:optima_sync_v2/app/presentation/content/bloc/content_state.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/add_content_form.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/content_card.dart';
import 'package:optima_sync_v2/app/presentation/content/pages/content_status_style.dart';

class ContentKanbanScreen extends StatefulWidget {
  final String campaignId;
  final String campaignName;

  final List<String>? campaignChannelIds;

  const ContentKanbanScreen({
    super.key,
    required this.campaignId,
    required this.campaignName,
    this.campaignChannelIds,
  });

  @override
  State<ContentKanbanScreen> createState() => _ContentKanbanScreenState();
}

class _ContentKanbanScreenState extends State<ContentKanbanScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ContentBloc>().add(
      LoadContents(campaignId: widget.campaignId),
    );
  }

  void _openAddContentForm() {
    final bloc = context.read<ContentBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: AddContentForm(
            campaignId: widget.campaignId,
            campaignChannelIds: widget.campaignChannelIds,
          ),
        );
      },
    );
  }

  void _moveToStatus(ContentEntity content, String newStatus) {
    if (content.status == newStatus) return;

    context.read<ContentBloc>().add(
      ContentStatusChanged(
        id: content.id!,
        campaignId: widget.campaignId,
        content: content,
        newStatus: newStatus,
      ),
    );
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }

          if (state is ContentFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
                        context.read<ContentBloc>().add(
                          LoadContents(campaignId: widget.campaignId),
                        );
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
                    const Icon(
                      Icons.view_kanban_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
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

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: kContentStatuses.map((status) {
                final columnItems = contents
                    .where((c) => c.status == status)
                    .toList();

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
    final color = ContentStatusStyle.color(status);

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
                color: isHovering
                    ? color.withOpacity(0.08)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isHovering ? color : Colors.grey.shade300,
                  width: isHovering ? 2 : 1,
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        ContentStatusStyle.icon(status),
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          ContentStatusStyle.label(status),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${items.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
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
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
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
