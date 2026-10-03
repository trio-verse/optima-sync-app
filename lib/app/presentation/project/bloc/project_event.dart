import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectEvent {
  const LoadProjects();
}

class CreateProjectSubmitted extends ProjectEvent {
  final ProjectInput input;
  const CreateProjectSubmitted(this.input);

  @override
  List<Object?> get props => [input];
}

class DeleteProjectSubmitted extends ProjectEvent {
  final String projectId;
  const DeleteProjectSubmitted(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class UpdateProjectSubmitted extends ProjectEvent {
  final String projectId;
  final ProjectUpdateInput input;
  const UpdateProjectSubmitted(this.projectId, this.input);

  @override
  List<Object?> get props => [projectId, input];
}
