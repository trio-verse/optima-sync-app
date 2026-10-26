import 'package:flutter/material.dart';
import 'package:optima_sync_v2/core/constants/appPallete.dart';

enum CampaignStatus {
  active('نشط', 'Active', AppPallete.success),
  draft('مسودة', 'Draft', AppPallete.textSecondary),
  paused('متوقف مؤقتاً', 'Paused', AppPallete.warning),
  completed('مكتملة', 'Completed', AppPallete.primary),
  cancelled('ملغية', 'Cancelled', AppPallete.danger);

  final String arabicStatus, englishStatus;
  final Color color;
  const CampaignStatus(this.arabicStatus, this.englishStatus, this.color);
}

class CampaignEntity {
  final String? id;
  final String name;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? expectedBudget;
  final int? estimatedContentCount;
  final CampaignStatus status;
  final String target;

  const CampaignEntity({
    this.id,
    required this.name,
    required this.description,
    this.startDate,
    this.endDate,
    this.expectedBudget,
    this.estimatedContentCount,
    this.status = CampaignStatus.draft,
    required this.target,
  });

  factory CampaignEntity.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] is Map ? Map<String, dynamic>.from(json['metrics']) : <String, dynamic>{};

    return CampaignEntity(
      id: metrics['id']?.toString(),
      name: metrics['name']?.toString() ?? '',
      description: metrics['description']?.toString() ?? '',
      startDate: DateTime.tryParse(metrics['start_date'] ?? ''),
      endDate: DateTime.tryParse(metrics['end_date'] ?? ""),
      expectedBudget: (metrics['expected_budget'] as num?)?.toDouble(),
      estimatedContentCount: (metrics['estimated_content_count'] as num?)?.toInt(),
      status: _statusParser(metrics['status'].toString()),
      target: metrics['target']?.toString() ?? '',
    );
  }

  static CampaignStatus _statusParser(String source) =>
      CampaignStatus.values.firstWhere((status) => status.name == source.toLowerCase(), orElse: () => .draft);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      if (startDate != null) "start_date": startDate?.toIso8601String(),
      if (endDate != null) "end_date": endDate?.toIso8601String(),
      if (expectedBudget != null) "expected_budget": expectedBudget,
      if (estimatedContentCount != null) "estimated_content_count": estimatedContentCount,
      "status": status.name,
      "target": target,
    };
  }

  CampaignEntity copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? expectedBudget,
    int? estimatedContentCount,
    CampaignStatus? status,
    String? target,
  }) {
    return CampaignEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      expectedBudget: expectedBudget ?? this.expectedBudget,
      estimatedContentCount: estimatedContentCount ?? this.estimatedContentCount,
      status: status ?? this.status,
      target: target ?? this.target,
    );
  }
}
