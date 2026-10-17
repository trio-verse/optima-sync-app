import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

class ContentStatus {
  ContentStatus._();

  static const String draft = 'draft';
  static const String inReview = 'in_review';
  static const String approved = 'approved';
  static const String rejected = 'rejected';
  static const String published = 'published';

  static const List<String> values = [
    draft,
    inReview,
    approved,
    rejected,
    published,
  ];

  static const List<String> pipeline = [draft, inReview, approved, rejected];

  static bool isCostConfirmed(String status) =>
      status == approved || status == published;

  static String label(String status) {
    switch (status) {
      case inReview:
        return 'In Review';
      case approved:
        return 'Approved';
      case rejected:
        return 'Rejected';
      case published:
        return 'Published';
      case draft:
      default:
        return 'Draft';
    }
  }

  static Color color(String status) {
    switch (status) {
      case inReview:
        return AppPallete.warning;
      case approved:
        return AppPallete.primary;
      case rejected:
        return AppPallete.danger;
      case published:
        return AppPallete.success;
      case draft:
      default:
        return AppPallete.textSecondary;
    }
  }

  static IconData icon(String status) {
    switch (status) {
      case inReview:
        return Icons.hourglass_top_outlined;
      case approved:
        return Icons.verified_outlined;
      case rejected:
        return Icons.cancel_outlined;
      case published:
        return Icons.public_outlined;
      case draft:
      default:
        return Icons.edit_note_outlined;
    }
  }
}

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
    this.status = ContentStatus.draft,
    this.publishedAt,
    this.description,
  });

  bool get isCostConfirmed => ContentStatus.isCostConfirmed(status);
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
      status: _asString(json['status']) ?? ContentStatus.draft,
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
