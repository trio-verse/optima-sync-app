import 'package:equatable/equatable.dart';

abstract class CaptureEvent extends Equatable {
  const CaptureEvent();

  @override
  List<Object?> get props => [];
}

class LoadCaptureSettings extends CaptureEvent {
  final String campaignId;

  const LoadCaptureSettings({required this.campaignId});

  @override
  List<Object?> get props => [campaignId];
}

class ToggleCaptureSubmitted extends CaptureEvent {
  final String campaignId;
  final bool enabled;

  const ToggleCaptureSubmitted({
    required this.campaignId,
    required this.enabled,
  });

  @override
  List<Object?> get props => [campaignId, enabled];
}

class RegenerateTokenSubmitted extends CaptureEvent {
  final String campaignId;

  const RegenerateTokenSubmitted({required this.campaignId});

  @override
  List<Object?> get props => [campaignId];
}
