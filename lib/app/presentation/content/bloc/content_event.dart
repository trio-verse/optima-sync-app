import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/content_entity.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class LoadContents extends ContentEvent {
  final String campaignId;

  const LoadContents({required this.campaignId});

  @override
  List<Object?> get props => [campaignId];
}

class AddContentSubmitted extends ContentEvent {
  final String campaignId;
  final ContentEntity content;

  const AddContentSubmitted({required this.campaignId, required this.content});

  @override
  List<Object?> get props => [campaignId, content];
}

class UpdateContentSubmitted extends ContentEvent {
  final String id;
  final String campaignId;
  final ContentEntity content;

  const UpdateContentSubmitted({
    required this.id,
    required this.campaignId,
    required this.content,
  });

  @override
  List<Object?> get props => [id, campaignId, content];
}

class ContentStatusChanged extends ContentEvent {
  final String id;
  final String campaignId;
  final ContentEntity content;
  final String newStatus;

  const ContentStatusChanged({
    required this.id,
    required this.campaignId,
    required this.content,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [id, campaignId, content, newStatus];
}

class DeleteContentSubmitted extends ContentEvent {
  final String id;
  final String campaignId;

  const DeleteContentSubmitted({required this.id, required this.campaignId});

  @override
  List<Object?> get props => [id, campaignId];
}
