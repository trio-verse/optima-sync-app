import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/task_mamagement/workspace_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/task_manager/task_manager_repo.dart';
import 'package:optima_sync_v2/core/errors/task_manager/task_manager_error.dart';

class TaskManagerUsecase {
  final TaskManagerRepo repo;

  TaskManagerUsecase({required this.repo});

  Future<Either<TaskManagerError, List<WorkspaceEntity>>> createWorkspace(WorkspaceEntity workspaceEntity) {
    return repo.createWorkspace(workspaceEntity);
  }

  Future<Either<TaskManagerError, List<WorkspaceEntity>>> deleteWorkspace(WorkspaceEntity workspaceEntity) {
    return repo.deleteWorkspace(workspaceEntity);
  }

  Future<Either<TaskManagerError, List<WorkspaceEntity>>> getAllWorkspaces() {
    return repo.getAllWorkspaces();
  }

  Future<Either<TaskManagerError, List<WorkspaceEntity>>> updateWorkspace(WorkspaceEntity workspaceEntity) {
    return repo.updateWorkspace(workspaceEntity);
  }
}
