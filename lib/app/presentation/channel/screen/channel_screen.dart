import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_event.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_state.dart';
import 'package:optima_sync_v2/app/presentation/channel/pages/add_channel_form.dart';
import 'package:optima_sync_v2/app/presentation/channel/pages/channel_list_item.dart';
import 'package:optima_sync_v2/app/presentation/channel/pages/edit_channel_form.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  final searchController = TextEditingController();

  String _query = '';

  @override
  void initState() {
    super.initState();

    context.read<ChannelBloc>().add(LoadChannels());

    searchController.addListener(() {
      setState(() {
        _query = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _openAddChannelForm() {
    final bloc = context.read<ChannelBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(value: bloc, child: const AddChannelForm());
      },
    );
  }

  void _openEditChannelForm(ChannelEntity channel) {
    final bloc = context.read<ChannelBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: EditChannelForm(channel: channel),
        );
      },
    );
  }

  void _showDeleteConfirmation(ChannelEntity channel) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Channel'),
          content: Text('Are you sure you want to delete "${channel.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                context.read<ChannelBloc>().add(
                  DeleteChannelSubmitted(id: channel.id!),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  List<ChannelEntity> _filter(List<ChannelEntity> channels) {
    if (_query.isEmpty) {
      return channels;
    }

    return channels
        .where((channel) => channel.name.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Channels')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddChannelForm,
        icon: const Icon(Icons.add),
        label: const Text('Add Channel'),
      ),

      body: BlocConsumer<ChannelBloc, ChannelState>(
        listener: (context, state) {
          if (state is ChannelFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          if (state is ChannelInitial || state is ChannelLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChannelFailure && state.channels == null) {
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
                        context.read<ChannelBloc>().add(LoadChannels());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final channels = switch (state) {
            ChannelSuccess(:final channels) => channels,
            ChannelSubmitting(:final channels) => channels,
            ChannelFailure(:final channels) => channels ?? const [],
            _ => const <ChannelEntity>[],
          };

          final filteredChannels = _filter(channels);

          final isSubmitting = state is ChannelSubmitting;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: TextField(
                  controller: searchController,
                  enabled: !isSubmitting,
                  decoration: InputDecoration(
                    hintText: 'Search channels',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: isSubmitting
                                ? null
                                : () {
                                    searchController.clear();
                                  },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              if (isSubmitting)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: LinearProgressIndicator(),
                ),

              Expanded(
                child: channels.isEmpty
                    ? const Center(child: Text('No channels yet'))
                    : filteredChannels.isEmpty
                    ? const Center(child: Text('No channels match your search'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredChannels.length,
                        separatorBuilder: (_, __) {
                          return const Divider(height: 1);
                        },
                        itemBuilder: (context, index) {
                          final channel = filteredChannels[index];

                          return ChannelListItem(
                            channel: channel,
                            isLoading: isSubmitting,
                            onEdit: isSubmitting
                                ? null
                                : () {
                                    _openEditChannelForm(channel);
                                  },
                            onDelete: isSubmitting
                                ? null
                                : () {
                                    _showDeleteConfirmation(channel);
                                  },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
