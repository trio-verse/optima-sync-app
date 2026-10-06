import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentSubmitting extends ContentState {
  final List<ContentEntity> contents;

  const ContentSubmitting({required this.contents});

  @override
  List<Object?> get props => [contents];
}

class ContentSuccess extends ContentState {
  final List<ContentEntity> contents;

  final String? message;

  const ContentSuccess({required this.contents, this.message});

  @override
  List<Object?> get props => [contents, message];
}

class ContentFailure extends ContentState {
  final String message;
  final List<ContentEntity>? contents;

  const ContentFailure({required this.message, this.contents});

  @override
  List<Object?> get props => [message, contents];
}
