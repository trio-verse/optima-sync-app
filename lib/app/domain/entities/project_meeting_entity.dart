class ProjectMeetingEntity {
  final String id;
  final String projectId;
  final String title;
  final DateTime? meetingDate;
  final String? meetingUrl;
  final String? description;
  final List<String> stakeholders;
  final List<String> teamMembers;

  ProjectMeetingEntity({
    required this.id,
    required this.projectId,
    required this.title,
    this.meetingDate,
    this.meetingUrl,
    this.description,
    this.stakeholders = const [],
    this.teamMembers = const [],
  });

  bool get isUpcoming =>
      meetingDate != null && meetingDate!.isAfter(DateTime.now());

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return null;
  }

  static DateTime? _asDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  factory ProjectMeetingEntity.fromJson(
    Map<String, dynamic> json, {
    String? projectId,
  }) {
    return ProjectMeetingEntity(
      id: json['id']?.toString() ?? '',
      projectId: _asString(json['project_id']) ?? projectId ?? '',
      title: _asString(json['title']) ?? '',

      meetingDate:
          _asDate(json['meeting_date']) ?? _asDate(json['scheduled_at']),
      meetingUrl:
          _asString(json['meeting_url']) ?? _asString(json['link_or_location']),
      description: _asString(json['description']),
      stakeholders: _asStringList(json['stakeholders']),
      teamMembers: _asStringList(json['team_members']),
    );
  }
}

class ProjectMeetingInput {
  final String title;
  final DateTime meetingDate;
  final String? meetingUrl;
  final String? description;
  final List<String> stakeholders;
  final List<String> teamMembers;

  const ProjectMeetingInput({
    required this.title,
    required this.meetingDate,
    this.meetingUrl,
    this.description,
    this.stakeholders = const [],
    this.teamMembers = const [],
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'meeting_date': meetingDate.toIso8601String(),
    if (meetingUrl != null && meetingUrl!.isNotEmpty) 'meeting_url': meetingUrl,
    if (description != null && description!.isNotEmpty)
      'description': description,
    if (stakeholders.isNotEmpty) 'stakeholders': stakeholders,
    if (teamMembers.isNotEmpty) 'team_members': teamMembers,
  };
}
