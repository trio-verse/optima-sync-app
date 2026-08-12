import 'package:equatable/equatable.dart';

abstract class SelectOrganizationEvent extends Equatable {
  const SelectOrganizationEvent();

  @override
  List<Object?> get props => [];
}

class SelectOrganizationSubmitted extends SelectOrganizationEvent {
  final String organizationId;

  const SelectOrganizationSubmitted({required this.organizationId});

  @override
  List<Object?> get props => [organizationId];
}

class LoadOrganizations extends SelectOrganizationEvent {}
