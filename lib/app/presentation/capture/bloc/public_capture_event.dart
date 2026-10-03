import 'package:equatable/equatable.dart';

abstract class PublicCaptureEvent extends Equatable {
  const PublicCaptureEvent();

  @override
  List<Object?> get props => [];
}

class LoadPublicCaptureForm extends PublicCaptureEvent {
  final String token;

  const LoadPublicCaptureForm({required this.token});

  @override
  List<Object?> get props => [token];
}

class SubmitPublicCaptureForm extends PublicCaptureEvent {
  final String token;
  final Map<String, dynamic> data;

  const SubmitPublicCaptureForm({required this.token, required this.data});

  @override
  List<Object?> get props => [token, data];
}
