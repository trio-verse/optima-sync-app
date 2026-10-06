import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/public_capture_form_entity.dart';

abstract class PublicCaptureState extends Equatable {
  const PublicCaptureState();

  @override
  List<Object?> get props => [];
}

class PublicCaptureInitial extends PublicCaptureState {}

class PublicCaptureLoading extends PublicCaptureState {}

class PublicCaptureLoaded extends PublicCaptureState {
  final PublicCaptureFormEntity form;

  const PublicCaptureLoaded({required this.form});

  @override
  List<Object?> get props => [form];
}

class PublicCaptureSubmitting extends PublicCaptureState {
  final PublicCaptureFormEntity form;

  const PublicCaptureSubmitting({required this.form});

  @override
  List<Object?> get props => [form];
}

class PublicCaptureSubmitted extends PublicCaptureState {}

class PublicCaptureFailure extends PublicCaptureState {
  final String message;

  const PublicCaptureFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
