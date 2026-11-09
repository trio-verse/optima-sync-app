import 'package:optima_sync_v2/core/constants/constants.dart';

class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String assignedBy;
  final Priority priority;
  final TaskStatus status;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedBy,
    required this.priority,
    required this.status,
  });

  TaskEntity copyWith({TaskStatus? status}) => TaskEntity(
    id: id,
    title: title,
    description: description,
    status: status ?? this.status,
    priority: priority,
    assignedBy: assignedBy,
  );
}
