import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

enum ContentStatus {
  draft("مسودة", "draft", AppPallete.textSecondary, Icons.edit_note_outlined),
  inReview("مسودة", "draft", AppPallete.warning, Icons.hourglass_top_outlined),
  approved("مقبول", "approved", AppPallete.primary, Icons.verified_outlined),
  rejecte("مقبول", "approved", AppPallete.danger, Icons.cancel_outlined),
  published("مقبول", "approved", AppPallete.success, Icons.public_outlined);

  final String arabicStatus, engStatus;
  final Color color;
  final IconData iconData;

  const ContentStatus(this.arabicStatus, this.engStatus, this.color, this.iconData);
}

class ContentEntity {
  final String? contentId;
  final String campaignId;
  final String channelId;
  final String title;
  final String type;
  final String script;

  final double? cost;
  final ContentStatus status;
  final String? publishedAt;
  final String? description;
  final String? assignedBy;

  const ContentEntity({
    this.contentId,
    required this.campaignId,
    required this.channelId,
    required this.title,
    required this.type,
    required this.script,
    this.cost,
    this.status = ContentStatus.draft,
    this.publishedAt,
    this.description,
    this.assignedBy,
  });

  factory ContentEntity.fromJson(Map<String, dynamic> json) {
    return ContentEntity(
      campaignId: (json['campaign_id']).toString(),
      channelId: (json['channel_id']).toString(),
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      script: json['script']?.toString() ?? '',
      cost: (json['cost'] as num?)?.toDouble(),
      status: (json['status']) ?? ContentStatus.draft.toString(),
      publishedAt: (json['published_at']).toString(),
      description: (json['description']).toString(),
      assignedBy: (json['assigned_by'])?.toString(),
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
      if (publishedAt != null && publishedAt!.isNotEmpty) "published_at": publishedAt,
      if (description != null && description!.isNotEmpty) "description": description,
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
    ContentStatus? status,
    String? publishedAt,
    String? description,
  }) {
    return ContentEntity(
      campaignId: campaignId ?? this.campaignId,
      channelId: channelId ?? this.channelId,
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
