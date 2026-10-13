import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/data/sources/remote_data/task_remote_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/task/task_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  bool get isConfigured => remoteDataSource.isConfigured;
  @override
  String get unavailableMessage => remoteDataSource.unavailableMessage;

  Future<Either<WhateverFailure, T>> _guard<T>(Future<T> request) async {
    try {
      return Right(await request);
    } catch (_) {
      return Left(WhateverFailure.serverError());
    }
  }

  @override
  Future<Either<WhateverFailure, TaskManagerAccess>> getAccess() =>
      _guard(remoteDataSource.getAccess());
  @override
  Future<Either<WhateverFailure, List<TaskEntity>>> getTasks(
    TaskFilter filter,
  ) => _guard(remoteDataSource.getTasks(filter));
  @override
  Future<Either<WhateverFailure, TaskEntity>> createTask(TaskInput input) =>
      _guard(remoteDataSource.createTask(input));
  @override
  Future<Either<WhateverFailure, TaskEntity>> updateTask(
    String taskId,
    TaskInput input,
  ) => _guard(remoteDataSource.updateTask(taskId, input));
  @override
  Future<Either<WhateverFailure, TaskEntity>> changeTaskStatus(
    String taskId,
    String status,
  ) => _guard(remoteDataSource.changeTaskStatus(taskId, status));
  @override
  Future<Either<WhateverFailure, void>> deleteTask(String taskId) =>
      _guard(remoteDataSource.deleteTask(taskId));
  @override
  Future<Either<WhateverFailure, List<TaskCategoryEntity>>> getCategories() =>
      _guard(remoteDataSource.getCategories());
  @override
  Future<Either<WhateverFailure, TaskCategoryEntity>> createCategory(
    String name,
  ) => _guard(remoteDataSource.createCategory(name));
  @override
  Future<Either<WhateverFailure, TaskCategoryEntity>> updateCategory(
    String categoryId,
    String name,
  ) => _guard(remoteDataSource.updateCategory(categoryId, name));
  @override
  Future<Either<WhateverFailure, void>> deleteCategory(String categoryId) =>
      _guard(remoteDataSource.deleteCategory(categoryId));
}
