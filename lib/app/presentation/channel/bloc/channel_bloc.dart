import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/channel_usecases.dart';

import 'channel_event.dart';
import 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelUsecases usecases;

  ChannelBloc({required this.usecases}) : super(ChannelInitial()) {
    on<LoadChannels>(_onLoadChannels);
    on<AddChannelSubmitted>(_onAddChannelSubmitted);
    on<UpdateChannelSubmitted>(_onUpdateChannelSubmitted);
    on<DeleteChannelSubmitted>(_onDeleteChannelSubmitted);
  }

  List<ChannelEntity> _getCurrentChannels() {
    final currentState = state;

    if (currentState is ChannelSuccess) {
      return currentState.channels;
    }

    if (currentState is ChannelSubmitting) {
      return currentState.channels;
    }

    if (currentState is ChannelFailure) {
      return currentState.channels ?? const [];
    }

    return const [];
  }

  Future<void> _onLoadChannels(
    LoadChannels event,
    Emitter<ChannelState> emit,
  ) async {
    emit(ChannelLoading());

    try {
      final channels = await usecases.getChannels();

      emit(ChannelSuccess(channels: channels));
    } catch (e) {
      emit(ChannelFailure(message: e.toString()));
    }
  }

  Future<void> _onAddChannelSubmitted(
    AddChannelSubmitted event,
    Emitter<ChannelState> emit,
  ) async {
    final existingChannels = _getCurrentChannels();

    final name = event.name.trim();

    if (name.isEmpty) {
      emit(
        ChannelFailure(
          message: 'Channel name cannot be empty',
          channels: existingChannels,
        ),
      );
      return;
    }

    final isDuplicate = existingChannels.any(
      (channel) => channel.name.trim().toLowerCase() == name.toLowerCase(),
    );

    if (isDuplicate) {
      emit(
        ChannelFailure(
          message: 'A channel with this name already exists',
          channels: existingChannels,
        ),
      );
      return;
    }

    emit(ChannelSubmitting(channels: existingChannels));

    try {
      final newChannel = await usecases.createChannel(
        name: name,
        color: _randomColor(),
      );

      emit(ChannelSuccess(channels: [newChannel, ...existingChannels]));
    } catch (e) {
      emit(ChannelFailure(message: e.toString(), channels: existingChannels));
    }
  }

  Future<void> _onUpdateChannelSubmitted(
    UpdateChannelSubmitted event,
    Emitter<ChannelState> emit,
  ) async {
    final existingChannels = _getCurrentChannels();

    final name = event.name.trim();

    if (name.isEmpty) {
      emit(
        ChannelFailure(
          message: 'Channel name cannot be empty',
          channels: existingChannels,
        ),
      );
      return;
    }

    final isDuplicate = existingChannels.any(
      (channel) =>
          channel.id != event.id &&
          channel.name.trim().toLowerCase() == name.toLowerCase(),
    );

    if (isDuplicate) {
      emit(
        ChannelFailure(
          message: 'A channel with this name already exists',
          channels: existingChannels,
        ),
      );
      return;
    }

    emit(ChannelSubmitting(channels: existingChannels));

    try {
      final updatedChannel = await usecases.updateChannel(
        id: event.id,
        name: name,
        color: event.color,
      );

      final updatedChannels = existingChannels.map((channel) {
        if (channel.id == event.id) {
          return updatedChannel;
        }

        return channel;
      }).toList();

      emit(ChannelSuccess(channels: updatedChannels));
    } catch (e) {
      emit(ChannelFailure(message: e.toString(), channels: existingChannels));
    }
  }

  Future<void> _onDeleteChannelSubmitted(
    DeleteChannelSubmitted event,
    Emitter<ChannelState> emit,
  ) async {
    final existingChannels = _getCurrentChannels();

    emit(ChannelSubmitting(channels: existingChannels));

    try {
      await usecases.deleteChannel(id: event.id);

      final updatedChannels = existingChannels
          .where((channel) => channel.id != event.id)
          .toList();

      emit(ChannelSuccess(channels: updatedChannels));
    } catch (e) {
      emit(ChannelFailure(message: e.toString(), channels: existingChannels));
    }
  }

  String _randomColor() {
    final random = Random();

    final value = random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');

    return '#${value.toUpperCase()}';
  }
}
