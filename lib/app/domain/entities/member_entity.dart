const List<String> kMemberRoles = ['member', 'admin'];

class MemberEntity {
  final String id;
  final String? organizationId;
  final String userId;
  final String role;
  final String? name;
  final String? email;
  final String? createdAt;
  final String? updatedAt;

  MemberEntity({
    required this.id,
    this.organizationId,
    required this.userId,
    required this.role,
    this.name,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return null;
  }

  factory MemberEntity.fromJson(Map<String, dynamic> json) {
    final dynamic userJson = json['user'];
    final Map<String, dynamic>? user = userJson is Map<String, dynamic>
        ? userJson
        : null;

    return MemberEntity(
      id: _asString(json['id']) ?? '',
      organizationId: _asString(json['organization_id']),
      userId: _asString(json['user_id'] ?? user?['id']) ?? '',
      role: _asString(json['role']) ?? 'member',
      name: _asString(user?['name'] ?? json['name']),
      email: _asString(user?['email'] ?? json['email']),
      createdAt: _asString(json['createdAt'] ?? json['created_at']),
      updatedAt: _asString(json['updatedAt'] ?? json['updated_at']),
    );
  }

  String get displayName {
    if (name != null && name!.trim().isNotEmpty) return name!;
    if (email != null && email!.trim().isNotEmpty) return email!;
    return 'Member #$userId';
  }

  MemberEntity copyWith({String? role}) {
    return MemberEntity(
      id: id,
      organizationId: organizationId,
      userId: userId,
      role: role ?? this.role,
      name: name,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
