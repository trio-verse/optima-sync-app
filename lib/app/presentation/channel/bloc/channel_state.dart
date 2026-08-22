import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/channel_entity.dart';

abstract class ChannelState extends Equatable {
  const ChannelState();

  @override
  List<Object?> get props => [];
}

class ChannelInitial extends ChannelState {}

class ChannelLoading extends ChannelState {}

class ChannelSuccess extends ChannelState {
  final List<ChannelEntity> channels;

  const ChannelSuccess({required this.channels});

  @override
  List<Object?> get props => [channels];
}

class ChannelSubmitting extends ChannelState {
  final List<ChannelEntity> channels;

  const ChannelSubmitting({required this.channels});

  @override
  List<Object?> get props => [channels];
}

class ChannelFailure extends ChannelState {
  final String message;
  final List<ChannelEntity>? channels;

  const ChannelFailure({required this.message, this.channels});

  @override
  List<Object?> get props => [message, channels];
}
