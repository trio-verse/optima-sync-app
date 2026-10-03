import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<ProjectEntity> projects;
  final List<ProjectClientOption> clients;
  final bool isWorking;
  final String? message;

  const ProjectLoaded({
    required this.projects,
    required this.clients,
    this.isWorking = false,
    this.message,
  });

  ProjectLoaded copyWith({
    List<ProjectEntity>? projects,
    List<ProjectClientOption>? clients,
    bool? isWorking,
    String? message,
    bool clearMessage = false,
  }) {
    return ProjectLoaded(
      projects: projects ?? this.projects,
      clients: clients ?? this.clients,
      isWorking: isWorking ?? this.isWorking,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [projects, clients, isWorking, message];
}

class ProjectFailure extends ProjectState {
  final String message;
  const ProjectFailure(this.message);

  @override
  List<Object?> get props => [message];
}
