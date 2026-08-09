import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';

abstract class SelectOrganizationState extends Equatable {
  const SelectOrganizationState();

  @override
  List<Object?> get props => [];
}

class SelectOrganizationInitial extends SelectOrganizationState {}

class SelectOrganizationLoading extends SelectOrganizationState {}

class SelectOrganizationSuccess extends SelectOrganizationState {
  final List<OrgEntity> organizations;
  final String? selectedId;

  const SelectOrganizationSuccess({
    required this.organizations,
    this.selectedId,
  });

  @override
  List<Object?> get props => [organizations, selectedId];
}

class SelectOrganizationSelected extends SelectOrganizationState {
  final String organizationId;

  const SelectOrganizationSelected({required this.organizationId});

  @override
  List<Object?> get props => [organizationId];
}

class SelectOrganizationFailure extends SelectOrganizationState {
  final String message;

  const SelectOrganizationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
