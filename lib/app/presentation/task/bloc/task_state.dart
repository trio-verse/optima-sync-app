import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/task_entity.dart';

class TaskManagerData {
  final TaskManagerAccess access;
  final List<TaskEntity> tasks;
  final List<TaskCategoryEntity> categories;
  final List<MemberEntity> members;
  final TaskFilter filter;

  const TaskManagerData({
    required this.access,
    required this.tasks,
    required this.categories,
    this.members = const [],
    this.filter = const TaskFilter(),
  });

  List<TaskEntity> get visibleTasks => tasks
      .where((task) => access.canViewTask(task) && filter.matches(task))
      .toList();

  TaskManagerData copyWith({
    List<TaskEntity>? tasks,
    List<TaskCategoryEntity>? categories,
    TaskFilter? filter,
  }) => TaskManagerData(
    access: access,
    tasks: tasks ?? this.tasks,
    categories: categories ?? this.categories,
    members: members,
    filter: filter ?? this.filter,
  );
}

abstract class TaskState extends Equatable {
  const TaskState();
  TaskManagerData? get data => null;
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}
class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  @override
  final TaskManagerData data;
  final String? message;
  final String? operation;
  const TaskLoaded(this.data, {this.message, this.operation});
  @override
  List<Object?> get props => [data, message, operation];
}

class TaskWorking extends TaskState {
  @override
  final TaskManagerData data;
  final String operation;
  const TaskWorking(this.data, this.operation);
  @override
  List<Object?> get props => [data, operation];
}

class TaskFailure extends TaskState {
  final String message;
  @override
  final TaskManagerData? data;
  const TaskFailure(this.message, {this.data});
  @override
  List<Object?> get props => [message, data];
}

class TaskUnavailable extends TaskState {
  final String message;
  const TaskUnavailable(this.message);
  @override
  List<Object?> get props => [message];
}
