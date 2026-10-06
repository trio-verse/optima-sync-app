import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_bloc.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_event.dart';
import 'package:optima_sync_v2/app/presentation/channel/bloc/channel_state.dart';
import 'package:optima_sync_v2/app/presentation/channel/pages/add_channel_form.dart';
import 'package:optima_sync_v2/app/presentation/channel/pages/channel_list_item.dart';
import 'package:optima_sync_v2/app/presentation/channel/pages/edit_channel_form.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class ChannelScreen extends StatefulWidget {
  final bool embedded;

  const ChannelScreen({super.key, this.embedded = false});

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
      backgroundColor: AppPallete.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
      backgroundColor: AppPallete.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
    final bloc = context.read<ChannelBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Channel',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppPallete.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${channel.name}"? This action cannot be undone.',
            style: const TextStyle(color: AppPallete.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppPallete.textSecondary,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();

                bloc.add(DeleteChannelSubmitted(id: channel.id!));
              },
              child: const Text('Confirm'),
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
      backgroundColor: AppPallete.pageBackground,
      appBar: widget.embedded
          ? null
          : AppBar(
              backgroundColor: AppPallete.pageBackground,
              surfaceTintColor: AppPallete.pageBackground,
              elevation: 0,
              foregroundColor: AppPallete.textPrimary,
              title: const Text('Channels'),
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddChannelForm,
        backgroundColor: AppPallete.industryPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Channel',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: BlocConsumer<ChannelBloc, ChannelState>(
        listener: (context, state) {
          if (state is ChannelFailure && state.channels != null) {
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
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppPallete.textPrimary),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.industryPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ChannelBloc>().add(LoadChannels());
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                const _ChannelsHeaderCard(),
                const SizedBox(height: 12),
                _SearchCard(
                  controller: searchController,
                  query: _query,
                  enabled: !isSubmitting,
                ),
                const SizedBox(height: 14),
                if (channels.isEmpty)
                  const _EmptyState(hasAnyData: false)
                else if (filteredChannels.isEmpty)
                  const _EmptyState(hasAnyData: true)
                else
                  for (final channel in filteredChannels)
                    ChannelListItem(
                      key: ValueKey(channel.id),
                      channel: channel,
                      isLoading: isSubmitting,
                      onEdit: () => _openEditChannelForm(channel),
                      onDelete: () => _showDeleteConfirmation(channel),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChannelsHeaderCard extends StatelessWidget {
  const _ChannelsHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppPallete.industryPrimarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.wifi_tethering,
              color: AppPallete.industryPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Channels Management',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: AppPallete.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage and organize the communication channels available in your system.',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppPallete.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final bool enabled;

  const _SearchCard({
    required this.controller,
    required this.query,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.cardBorder),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(fontSize: 14, color: AppPallete.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search channels...',
          hintStyle: const TextStyle(
            color: AppPallete.textSecondary,
            fontSize: 13.5,
          ),
          prefixIcon: const Icon(Icons.search, color: AppPallete.textSecondary),
          suffixIcon: (query.isEmpty || !enabled)
              ? null
              : IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                    color: AppPallete.textSecondary,
                  ),
                  onPressed: controller.clear,
                ),
          filled: true,
          fillColor: AppPallete.inputFill,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasAnyData;

  const _EmptyState({required this.hasAnyData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppPallete.placeholderBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_tethering,
              color: AppPallete.placeholderIcon,
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasAnyData ? 'No matching channels' : 'No channels yet',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasAnyData
                ? 'Try a different search term'
                : 'Channels you add will show up here',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppPallete.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
