const List<String> kContentStatuses = [
  'draft',
  'in_review',
  'approved',
  'rejected',
  'published',
];

class ContentEntity {
  final String? id;
  final String campaignId;
  final String channelId;
  final String? channelName;
  final String title;
  final String type;
  final String script;

  final double? cost;
  final String status;
  final String? publishedAt;
  final String? description;

  const ContentEntity({
    this.id,
    required this.campaignId,
    required this.channelId,
    this.channelName,
    required this.title,
    required this.type,
    required this.script,
    this.cost,
    this.status = 'draft',
    this.publishedAt,
    this.description,
  });

  bool get isCostConfirmed => status == 'approved' || status == 'published';

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  static String? _idOf(dynamic value) {
    if (value == null) return null;
    if (value is Map) return value['id']?.toString();
    final asString = value.toString();
    return asString.isEmpty ? null : asString;
  }

  static String? _nameOf(dynamic value) {
    if (value is Map) {
      return (value['name'] ?? value['title'])?.toString();
    }
    return null;
  }

  factory ContentEntity.fromJson(Map<String, dynamic> json) {
    return ContentEntity(
      id: json['id']?.toString(),
      campaignId: _idOf(json['campaign_id'] ?? json['campaign']) ?? '',
      channelId: _idOf(json['channel_id'] ?? json['channel']) ?? '',
      channelName: _nameOf(json['channel']) ?? json['channel_name']?.toString(),
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      script: json['script']?.toString() ?? '',
      cost: _toDouble(json['cost']),
      status: _asString(json['status']) ?? 'draft',
      publishedAt: _asString(json['published_at']),
      description: _asString(json['description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "campaign_id": campaignId,
      "channel_id": channelId,
      "title": title,
      "type": type,
      "script": script,
      if (cost != null) "cost": cost,
      "status": status,
      if (publishedAt != null && publishedAt!.isNotEmpty)
        "published_at": publishedAt,
      if (description != null && description!.isNotEmpty)
        "description": description,
    };
  }

  ContentEntity copyWith({
    String? id,
    String? campaignId,
    String? channelId,
    String? channelName,
    String? title,
    String? type,
    String? script,
    double? cost,
    String? status,
    String? publishedAt,
    String? description,
  }) {
    return ContentEntity(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      title: title ?? this.title,
      type: type ?? this.type,
      script: script ?? this.script,
      cost: cost ?? this.cost,
      status: status ?? this.status,
      publishedAt: publishedAt ?? this.publishedAt,
      description: description ?? this.description,
    );
  }
}
