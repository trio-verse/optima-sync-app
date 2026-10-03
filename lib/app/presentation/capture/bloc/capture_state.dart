import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/capture_settings_entity.dart';

abstract class CaptureState extends Equatable {
  const CaptureState();

  @override
  List<Object?> get props => [];
}

class CaptureInitial extends CaptureState {}

class CaptureLoading extends CaptureState {}

class CaptureSubmitting extends CaptureState {
  final CaptureSettingsEntity settings;

  const CaptureSubmitting({required this.settings});

  @override
  List<Object?> get props => [settings];
}

class CaptureSuccess extends CaptureState {
  final CaptureSettingsEntity settings;
  final String? message;

  const CaptureSuccess({required this.settings, this.message});

  @override
  List<Object?> get props => [settings, message];
}

class CaptureFailure extends CaptureState {
  final String message;
  final CaptureSettingsEntity? settings;

  const CaptureFailure({required this.message, this.settings});

  @override
  List<Object?> get props => [message, settings];
}
