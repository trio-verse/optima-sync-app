import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/project_usecases.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectUsecases usecases;

  ProjectBloc({required this.usecases}) : super(ProjectInitial()) {
    on<LoadProjects>(_load);
    on<CreateProjectSubmitted>(_create);
    on<UpdateProjectSubmitted>(_update);
    on<DeleteProjectSubmitted>(_delete);
  }

  Future<void> _load(LoadProjects event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    final projectsResult = await usecases.getProjects(
      const ProjectFilter(perPage: 100),
    );
    await projectsResult.fold(
      (_) async => emit(ProjectFailure('Unable to load projects.')),
      (projectsPage) async {
        final clientsResult = await usecases.getClients();
        clientsResult.fold(
          (_) => emit(
            ProjectLoaded(projects: projectsPage.projects, clients: const []),
          ),
          (clients) => emit(
            ProjectLoaded(projects: projectsPage.projects, clients: clients),
          ),
        );
      },
    );
  }

  Future<void> _create(
    CreateProjectSubmitted event,
    Emitter<ProjectState> emit,
  ) async {
    final current = state;
    if (current is! ProjectLoaded) return;
    emit(current.copyWith(isWorking: true, clearMessage: true));
    final result = await usecases.createProject(event.input);
    await result.fold(
      (_) async => emit(
        current.copyWith(
          isWorking: false,
          message: 'Unable to create the project.',
        ),
      ),
      (created) async {
        final refreshed = await usecases.getProjects(
          const ProjectFilter(perPage: 100),
        );
        refreshed.fold(
          (_) => emit(
            current.copyWith(
              projects: [created, ...current.projects],
              isWorking: false,
              message: 'Project created successfully.',
            ),
          ),
          (page) => emit(
            current.copyWith(
              projects: page.projects,
              isWorking: false,
              message: 'Project created successfully.',
            ),
          ),
        );
      },
    );
  }

  Future<void> _update(
    UpdateProjectSubmitted event,
    Emitter<ProjectState> emit,
  ) async {
    final current = state;
    if (current is! ProjectLoaded) return;
    emit(current.copyWith(isWorking: true, clearMessage: true));
    final result = await usecases.updateProject(event.projectId, event.input);
    await result.fold(
      (_) async => emit(
        current.copyWith(
          isWorking: false,
          message: 'Unable to update the project.',
        ),
      ),
      (_) async {
        final refreshed = await usecases.getProjects(
          const ProjectFilter(perPage: 100),
        );
        refreshed.fold(
          (_) => emit(
            current.copyWith(
              isWorking: false,
              message: 'Project updated successfully.',
            ),
          ),
          (page) => emit(
            current.copyWith(
              projects: page.projects,
              isWorking: false,
              message: 'Project updated successfully.',
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(
    DeleteProjectSubmitted event,
    Emitter<ProjectState> emit,
  ) async {
    final current = state;
    if (current is! ProjectLoaded) return;
    emit(current.copyWith(isWorking: true, clearMessage: true));
    final result = await usecases.deleteProject(event.projectId);
    result.fold(
      (_) => emit(
        current.copyWith(
          isWorking: false,
          message: 'Unable to delete the project.',
        ),
      ),
      (_) => emit(
        current.copyWith(
          projects: current.projects
              .where((project) => project.id != event.projectId)
              .toList(),
          isWorking: false,
          message: 'Project deleted successfully.',
        ),
      ),
    );
  }
}
