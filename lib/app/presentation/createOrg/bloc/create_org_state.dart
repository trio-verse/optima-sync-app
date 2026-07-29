import 'package:equatable/equatable.dart';

abstract class CreateOrgState extends Equatable {
  const CreateOrgState();

  @override
  List<Object> get props => [];
}

class CreateOrgInitial extends CreateOrgState {}

class CreateOrgLoading extends CreateOrgState {}

class CreateOrgImageSelected extends CreateOrgState {
  final String imagePath;

  const CreateOrgImageSelected({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

class CreateOrgSuccess extends CreateOrgState {}

class CreateOrgFailure extends CreateOrgState {
  final String message;

  const CreateOrgFailure({required this.message});

  @override
  List<Object> get props => [message];
}
