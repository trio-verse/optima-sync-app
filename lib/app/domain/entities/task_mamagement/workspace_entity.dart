import 'package:optima_sync_v2/app/domain/entities/member_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/task_mamagement/task_entity.dart';

class WorkspaceEntity {
  final String id;
  final String title;
  final String description;
  final List<MemberEntity> members;
  final List<TaskEntity> tasks;
  final DateTime deadline;

  WorkspaceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.members,
    required this.tasks,
    required this.deadline,
  });
}
