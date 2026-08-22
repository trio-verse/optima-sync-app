import 'package:equatable/equatable.dart';

abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object?> get props => [];
}

class LoadChannels extends ChannelEvent {}

class AddChannelSubmitted extends ChannelEvent {
  final String name;

  const AddChannelSubmitted({required this.name});

  @override
  List<Object?> get props => [name];
}

class UpdateChannelSubmitted extends ChannelEvent {
  final String id;
  final String name;
  final String color;

  const UpdateChannelSubmitted({
    required this.id,
    required this.name,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, color];
}

class DeleteChannelSubmitted extends ChannelEvent {
  final String id;

  const DeleteChannelSubmitted({required this.id});

  @override
  List<Object?> get props => [id];
}
