const List<String> kTaskStatuses = ['Pending', 'Assigned', 'In Progress', 'Completed'];

class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String? categoryId;
  final String? categoryName;
  final String? memberId;
  final String? memberName;
  final DateTime? dueDate;
  final String status;
  final String priority;
  final String assignedBy;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    this.categoryId,
    this.categoryName,
    this.memberId,
    this.memberName,
    this.dueDate,
    required this.status,
    required this.priority,
    required this.assignedBy,
  });
}

class TaskInput {
  final String title;
  final String description;
  final String? categoryId;
  final String? memberId;
  final DateTime? dueDate;
  final String status;
  final String priority;

  const TaskInput({
    required this.title,
    required this.description,
    this.categoryId,
    this.memberId,
    this.dueDate,
    required this.status,
    required this.priority,
  });
}

class TaskCategoryEntity {
  final String id;
  final String name;

  const TaskCategoryEntity({required this.id, required this.name});
}

class TaskManagerAccess {
  final String role;
  final String? memberId;
  final bool mayManageTasks;
  final bool mayManageCategories;
  final bool mayChangeOwnStatus;
  final List<String> allowedStatuses;

  const TaskManagerAccess({
    required this.role,
    this.memberId,
    this.mayManageTasks = false,
    this.mayManageCategories = false,
    this.mayChangeOwnStatus = false,
    this.allowedStatuses = const [],
  });

  bool get isManager => role == 'manager';
  bool get isEmployee => role == 'employee';
  bool get canViewTasks => isManager || (isEmployee && (memberId?.trim().isNotEmpty ?? false));
  bool get canManageTasks => isManager && mayManageTasks;
  bool get canManageCategories => isManager && mayManageCategories;

  bool canViewTask(TaskEntity task) => isManager || (canViewTasks && task.memberId == memberId);

  bool canChangeStatus(TaskEntity task) =>
      allowedStatuses.any(kTaskStatuses.contains) &&
      (canManageTasks || (isEmployee && mayChangeOwnStatus && canViewTask(task)));

  // Resolve role, memberId and permissions from authenticated server data.
  // Existing organization roles admin/member are not mapped automatically.
}

class TaskFilter {
  final String? memberId;
  final String? categoryId;
  final DateTime? fromDate;
  final DateTime? toDate;

  const TaskFilter({this.memberId, this.categoryId, this.fromDate, this.toDate});

  bool get isValid => fromDate == null || toDate == null || !_dateOnly(fromDate!).isAfter(_dateOnly(toDate!));

  bool get isActive => memberId != null || categoryId != null || fromDate != null || toDate != null;

  TaskFilter forAccess(TaskManagerAccess access) => TaskFilter(
    memberId: access.isEmployee ? access.memberId : memberId,
    categoryId: categoryId,
    fromDate: fromDate,
    toDate: toDate,
  );

  bool matches(TaskEntity task) {
    if (memberId != null && task.memberId != memberId) return false;
    if (categoryId != null && task.categoryId != categoryId) return false;
    if (fromDate != null || toDate != null) {
      if (task.dueDate == null) return false;
      final date = _dateOnly(task.dueDate!);
      if (fromDate != null && date.isBefore(_dateOnly(fromDate!))) return false;
      if (toDate != null && date.isAfter(_dateOnly(toDate!))) return false;
    }
    return true;
  }

  static DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
}
