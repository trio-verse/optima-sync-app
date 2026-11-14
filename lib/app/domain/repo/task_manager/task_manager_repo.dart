import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/task_mamagement/workspace_entity.dart';
import 'package:optima_sync_v2/core/errors/task_manager/task_manager_error.dart';

abstract class TaskManagerRepo {
  Future<Either<TaskManagerError, List<WorkspaceEntity>>> getAllWorkspaces();
  Future<Either<TaskManagerError, List<WorkspaceEntity>>> createWorkspace(WorkspaceEntity workspaceEntity);
  Future<Either<TaskManagerError, List<WorkspaceEntity>>> updateWorkspace(WorkspaceEntity workspaceEntity);
  Future<Either<TaskManagerError, List<WorkspaceEntity>>> deleteWorkspace(WorkspaceEntity workspaceEntity);
}
