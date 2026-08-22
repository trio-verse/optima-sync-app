import 'package:equatable/equatable.dart';

abstract class UploadOrgLogoEvent extends Equatable {
  const UploadOrgLogoEvent();

  @override
  List<Object?> get props => [];
}

class PickAndUploadLogoEvent extends UploadOrgLogoEvent {
  final String organizationId;

  const PickAndUploadLogoEvent({required this.organizationId});

  @override
  List<Object?> get props => [organizationId];
}
