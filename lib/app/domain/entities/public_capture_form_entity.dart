class PublicCaptureFormEntity {
  final Map<String, dynamic> raw;

  const PublicCaptureFormEntity({required this.raw});

  factory PublicCaptureFormEntity.fromJson(Map<String, dynamic> json) {
    return PublicCaptureFormEntity(raw: json);
  }

  String? get campaignName =>
      raw['campaign_name']?.toString() ?? raw['name']?.toString();

  String? get description => raw['description']?.toString();
}
