import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/presentation/Org/screens/create_and_apdate_Org_screen.dart';

abstract class CreateAndUpdateOrgState extends Equatable {
  const CreateAndUpdateOrgState();

  @override
  List<Object> get props => [];
}

class CreateAndUpdateOrgInitial extends CreateAndUpdateOrgState {}

class CreateAndUpdateOrgLoading extends CreateAndUpdateOrgState {}

class CreateAndUpdateOrgSuccess extends CreateAndUpdateOrgState {
  final String organizationId;

  const CreateAndUpdateOrgSuccess({required this.organizationId});

  @override
  List<Object> get props => [organizationId];
}

class CreateAndUpdateOrgFailure extends CreateAndUpdateOrgState {
  final String message;

  const CreateAndUpdateOrgFailure({required this.message});

  @override
  List<Object> get props => [message];
}
