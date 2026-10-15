import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/core/errors/failures/failures.dart';

abstract class TaskRepository {
  bool get isConfigured;
  String get unavailableMessage;
  Future<Either<WhateverFailure, TaskManagerAccess>> getAccess();
  Future<Either<WhateverFailure, List<TaskEntity>>> getTasks(TaskFilter filter);
  Future<Either<WhateverFailure, TaskEntity>> createTask(TaskInput input);
  Future<Either<WhateverFailure, TaskEntity>> updateTask(
    String taskId,
    TaskInput input,
  );
  Future<Either<WhateverFailure, TaskEntity>> changeTaskStatus(
    String taskId,
    String status,
  );
  Future<Either<WhateverFailure, void>> deleteTask(String taskId);
  Future<Either<WhateverFailure, List<TaskCategoryEntity>>> getCategories();
  Future<Either<WhateverFailure, TaskCategoryEntity>> createCategory(
    String name,
  );
  Future<Either<WhateverFailure, TaskCategoryEntity>> updateCategory(
    String categoryId,
    String name,
  );
  Future<Either<WhateverFailure, void>> deleteCategory(String categoryId);
}
