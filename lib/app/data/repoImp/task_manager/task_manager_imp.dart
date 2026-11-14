import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/task_mamagement/workspace_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/task_manager/task_manager_repo.dart';
import 'package:optima_sync_v2/core/errors/task_manager/task_manager_error.dart';

class TaskManagerImp implements TaskManagerRepo {
  @override
  Future<Either<TaskManagerError, List<WorkspaceEntity>>> createWorkspace(WorkspaceEntity workspaceEntity) {
    // TODO: implement createWorkspace
    throw UnimplementedError();
  }

  @override
  Future<Either<TaskManagerError, List<WorkspaceEntity>>> deleteWorkspace(WorkspaceEntity workspaceEntity) {
    // TODO: implement deleteWorkspace
    throw UnimplementedError();
  }

  @override
  Future<Either<TaskManagerError, List<WorkspaceEntity>>> getAllWorkspaces() {
    // TODO: implement getAllWorkspaces
    throw UnimplementedError();
  }

  @override
  Future<Either<TaskManagerError, List<WorkspaceEntity>>> updateWorkspace(WorkspaceEntity workspaceEntity) {
    // TODO: implement updateWorkspace
    throw UnimplementedError();
  }
}
