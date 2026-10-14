import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/task/task_repo.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';

class TaskUsecases {
  final TaskRepository repo;
  TaskUsecases({required this.repo});

  bool get isConfigured => repo.isConfigured;
  String get unavailableMessage => repo.unavailableMessage;
  Future<Either<WhateverFailure, TaskManagerAccess>> getAccess() =>
      repo.getAccess();
  Future<Either<WhateverFailure, List<TaskEntity>>> getTasks(
    TaskFilter filter,
  ) => repo.getTasks(filter);
  Future<Either<WhateverFailure, TaskEntity>> createTask(TaskInput input) =>
      repo.createTask(input);
  Future<Either<WhateverFailure, TaskEntity>> updateTask(
    String taskId,
    TaskInput input,
  ) => repo.updateTask(taskId, input);
  Future<Either<WhateverFailure, TaskEntity>> changeTaskStatus(
    String taskId,
    String status,
  ) => repo.changeTaskStatus(taskId, status);
  Future<Either<WhateverFailure, void>> deleteTask(String taskId) =>
      repo.deleteTask(taskId);
  Future<Either<WhateverFailure, List<TaskCategoryEntity>>> getCategories() =>
      repo.getCategories();
  Future<Either<WhateverFailure, TaskCategoryEntity>> createCategory(
    String name,
  ) => repo.createCategory(name);
  Future<Either<WhateverFailure, TaskCategoryEntity>> updateCategory(
    String categoryId,
    String name,
  ) => repo.updateCategory(categoryId, name);
  Future<Either<WhateverFailure, void>> deleteCategory(String categoryId) =>
      repo.deleteCategory(categoryId);
}
