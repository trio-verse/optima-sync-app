import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final TaskFilter? filter;
  const LoadTasks({this.filter});
  @override
  List<Object?> get props => [filter];
}

class CreateTaskSubmitted extends TaskEvent {
  final TaskInput input;
  const CreateTaskSubmitted(this.input);
  @override
  List<Object?> get props => [input];
}

class UpdateTaskSubmitted extends TaskEvent {
  final String taskId;
  final TaskInput input;
  const UpdateTaskSubmitted(this.taskId, this.input);
  @override
  List<Object?> get props => [taskId, input];
}

class DeleteTaskSubmitted extends TaskEvent {
  final String taskId;
  const DeleteTaskSubmitted(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class ChangeTaskStatusSubmitted extends TaskEvent {
  final String taskId;
  final String status;
  const ChangeTaskStatusSubmitted(this.taskId, this.status);
  @override
  List<Object?> get props => [taskId, status];
}

class CreateTaskCategorySubmitted extends TaskEvent {
  final String name;
  const CreateTaskCategorySubmitted(this.name);
  @override
  List<Object?> get props => [name];
}

class UpdateTaskCategorySubmitted extends TaskEvent {
  final String categoryId;
  final String name;
  const UpdateTaskCategorySubmitted(this.categoryId, this.name);
  @override
  List<Object?> get props => [categoryId, name];
}

class DeleteTaskCategorySubmitted extends TaskEvent {
  final String categoryId;
  const DeleteTaskCategorySubmitted(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}
