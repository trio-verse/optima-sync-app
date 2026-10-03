import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_feature_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/project_meeting_entity.dart';

class ProjectCostEntity {
  final String id;
  final String name;
  final String? description;
  final int quantity;
  final double amount;

  const ProjectCostEntity({
    required this.id,
    required this.name,
    this.description,
    required this.quantity,
    required this.amount,
  });

  double get total => quantity * amount;

  factory ProjectCostEntity.fromJson(Map<String, dynamic> json) {
    return ProjectCostEntity(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      description: json['description']?.toString(),
      quantity: int.tryParse('${json['quantity'] ?? 1}') ?? 1,
      amount: double.tryParse('${json['amount'] ?? 0}') ?? 0,
    );
  }
}

class ProjectCostInput {
  final String name;
  final String? description;
  final int quantity;
  final double amount;

  const ProjectCostInput({
    required this.name,
    this.description,
    required this.quantity,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null && description!.isNotEmpty)
      'description': description,
    'quantity': quantity,
    'amount': amount,
  };
}

class ProjectVersionEntity {
  final String id;
  final String title;
  final String? description;
  final String? changeDescription;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? duration;
  final bool isActive;

  const ProjectVersionEntity({
    required this.id,
    required this.title,
    this.description,
    this.changeDescription,
    this.startDate,
    this.endDate,
    this.duration,
    this.isActive = false,
  });

  factory ProjectVersionEntity.fromJson(Map<String, dynamic> json) {
    return ProjectVersionEntity(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? json['version_number'] ?? 'Version'}',
      description: json['description']?.toString(),
      changeDescription: json['change_description']?.toString(),
      startDate: DateTime.tryParse('${json['start_date'] ?? ''}'),
      endDate: DateTime.tryParse('${json['end_date'] ?? ''}'),
      duration: json['duration']?.toString(),
      isActive:
          json['is_active'] == true ||
          '${json['status'] ?? ''}'.toLowerCase() == 'active',
    );
  }
}

class ProjectEmployeeEntity {
  final String id;
  final String employeeId;
  final EmployeeEntity? employee;
  final int totalPoints;

  const ProjectEmployeeEntity({
    required this.id,
    required this.employeeId,
    this.employee,
    required this.totalPoints,
  });

  factory ProjectEmployeeEntity.fromJson(Map<String, dynamic> json) {
    final employeeJson = json['employee'];
    return ProjectEmployeeEntity(
      id: '${json['id'] ?? ''}',
      employeeId: '${json['employee_id'] ?? (employeeJson is Map ? employeeJson['id'] : '')}',
      employee: employeeJson is Map
          ? EmployeeEntity.fromJson(Map<String, dynamic>.from(employeeJson))
          : null,
      totalPoints: int.tryParse('${json['total_points'] ?? 0}') ?? 0,
    );
  }
}

class ProjectDetailsData {
  final ProjectEntity project;
  final List<ProjectVersionEntity> versions;
  final List<ProjectFeatureEntity> features;
  final List<ProjectCostEntity> costs;
  final List<ProjectEmployeeEntity> team;
  final List<ProjectMeetingEntity> meetings;
  final List<EmployeeEntity> availableEmployees;
  final String? selectedVersionId;

  const ProjectDetailsData({
    required this.project,
    required this.versions,
    required this.features,
    required this.costs,
    required this.team,
    required this.meetings,
    required this.availableEmployees,
    this.selectedVersionId,
  });

  ProjectDetailsData copyWith({String? selectedVersionId}) {
    return ProjectDetailsData(
      project: project,
      versions: versions,
      features: features,
      costs: costs,
      team: team,
      meetings: meetings,
      availableEmployees: availableEmployees,
      selectedVersionId: selectedVersionId ?? this.selectedVersionId,
    );
  }
}
