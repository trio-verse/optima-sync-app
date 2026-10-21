import 'package:optima_sync_v2/app/data/sources/local_data/org_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';

class TaskRemoteDataSource {
  final HttpClientHelper client;
  final OrgLocalDataSource orgLocalDataSource;

  TaskRemoteDataSource({required this.client, required this.orgLocalDataSource});

  bool get isConfigured => false;
  String get unavailableMessage => 'Task Manager is not connected yet. Tasks and categories are unavailable.';

  Future<TaskManagerAccess> getAccess() async => throw UnsupportedError(unavailableMessage);
  Future<List<TaskEntity>> getTasks(TaskFilter filter) async => throw UnsupportedError(unavailableMessage);
  Future<TaskEntity> createTask(TaskInput input) async => throw UnsupportedError(unavailableMessage);
  Future<TaskEntity> updateTask(String taskId, TaskInput input) async => throw UnsupportedError(unavailableMessage);
  Future<TaskEntity> changeTaskStatus(String taskId, String status) async => throw UnsupportedError(unavailableMessage);
  Future<void> deleteTask(String taskId) async => throw UnsupportedError(unavailableMessage);
  Future<List<TaskCategoryEntity>> getCategories() async => throw UnsupportedError(unavailableMessage);
  Future<TaskCategoryEntity> createCategory(String name) async => throw UnsupportedError(unavailableMessage);
  Future<TaskCategoryEntity> updateCategory(String categoryId, String name) async =>
      throw UnsupportedError(unavailableMessage);
  Future<void> deleteCategory(String categoryId) async => throw UnsupportedError(unavailableMessage);
}
