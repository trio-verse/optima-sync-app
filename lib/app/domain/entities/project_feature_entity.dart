const List<String> kFeatureStatuses = [
  'new',
  'in_progress',
  'on_hold',
  'completed',
];

class ProjectFeatureEntity {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final String status;

  ProjectFeatureEntity({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    required this.status,
  });

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return null;
  }

  factory ProjectFeatureEntity.fromJson(
    Map<String, dynamic> json, {
    String? projectId,
  }) {
    return ProjectFeatureEntity(
      id: json['id']?.toString() ?? '',
      projectId: _asString(json['project_id']) ?? projectId ?? '',

      name: _asString(json['name']) ?? _asString(json['title']) ?? '',
      description: _asString(json['description']),
      status: _asString(json['status']) ?? 'new',
    );
  }

  ProjectFeatureEntity copyWith({String? status}) {
    return ProjectFeatureEntity(
      id: id,
      projectId: projectId,
      name: name,
      description: description,
      status: status ?? this.status,
    );
  }
}

class ProjectFeatureInput {
  final String name;
  final String? description;
  final String status;

  const ProjectFeatureInput({
    required this.name,
    this.description,
    this.status = 'new',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null && description!.isNotEmpty)
      'description': description,
    'status': status,
  };
}
