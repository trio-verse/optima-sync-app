import 'package:optima_sync_v2/core/constants/constants.dart';

class TaskEntity {
  final String id;
  final String name;
  final String description;
  final String assigneeId;
  final Priority priority;
  final TaskStatus taskStatus;

  TaskEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.assigneeId,
    required this.priority,
    required this.taskStatus,
  });
}
