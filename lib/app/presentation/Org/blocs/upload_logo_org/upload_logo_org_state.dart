import 'package:equatable/equatable.dart';

abstract class UploadOrgLogoState extends Equatable {
  const UploadOrgLogoState();

  @override
  List<Object?> get props => [];
}

class UploadOrgLogoInitial extends UploadOrgLogoState {}

class UploadOrgLogoLoading extends UploadOrgLogoState {}

class UploadOrgLogoSuccess extends UploadOrgLogoState {
  final String imageUrl;

  const UploadOrgLogoSuccess({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class UploadOrgLogoFailure extends UploadOrgLogoState {
  final String message;

  const UploadOrgLogoFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
