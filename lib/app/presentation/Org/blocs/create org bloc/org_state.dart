import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/presentation/Org/screens/create_and_apdate_Org_screen.dart';

abstract class CreateOrgState extends Equatable {
  const CreateOrgState();

  @override
  List<Object> get props => [];
}

class CreateOrgInitial extends CreateOrgState {}

class CreateOrgLoading extends CreateOrgState {}

class CreateOrgSuccess extends CreateOrgState {
  final String organizationId;

  const CreateOrgSuccess({required this.organizationId});

  @override
  List<Object> get props => [organizationId];
}

class CreateOrgFailure extends CreateOrgState {
  final String message;

  const CreateOrgFailure({required this.message});

  @override
  List<Object> get props => [message];
}
