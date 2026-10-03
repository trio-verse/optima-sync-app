import 'package:flutter/material.dart';

class ConnectionStage {
  ConnectionStage._();

  static const String lead = 'lead';
  static const String contacted = 'conected';
  static const String missingInfo = 'missing_info';
  static const String interested = 'intrested';
  static const String notInterested = 'not_intrested';
  static const String won = 'win';
  static const String closed = 'closed';

  static const List<String> values = [
    lead,
    contacted,
    missingInfo,
    interested,
    notInterested,
    won,
    closed,
  ];

  static String label(String stage) {
    switch (stage) {
      case lead:
        return 'Lead';
      case contacted:
        return 'Contacted';
      case missingInfo:
        return 'Missing Info';
      case interested:
        return 'Interested';
      case notInterested:
        return 'Not Interested';
      case won:
        return 'Won';
      case closed:
        return 'Closed';
      default:
        return stage;
    }
  }

  static Color color(String stage) {
    switch (stage) {
      case lead:
        return Colors.blueGrey;
      case contacted:
        return Colors.blue;
      case missingInfo:
        return Colors.orange;
      case interested:
        return Colors.purple;
      case notInterested:
        return Colors.red;
      case won:
        return Colors.green;
      case closed:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class InitiatedBy {
  InitiatedBy._();

  static const String client = 'client';
  static const String salesRep = 'sales_rep';

  static const List<String> values = [client, salesRep];

  static String label(String value) {
    switch (value) {
      case client:
        return 'Client';
      case salesRep:
        return 'Sales Rep';
      default:
        return value;
    }
  }
}

class ConnectionEntity {
  final String? id;
  final String? clientId;
  final String? clientName;

  final String productId;
  final String? productName;
  final double? productPrice;

  final String stage;

  final String? channelId;
  final String? channelName;

  final String? assigneeId;
  final String? assigneeName;

  final String? initiatedBy;
  final String? campaignId;
  final String? campaignName;

  final double? dealValue;

  final DateTime? createdAt;

  ConnectionEntity({
    this.id,
    this.clientId,
    this.clientName,
    required this.productId,
    this.productName,
    this.productPrice,
    required this.stage,
    this.channelId,
    this.channelName,
    this.assigneeId,
    this.assigneeName,
    this.initiatedBy,
    this.campaignId,
    this.campaignName,
    this.dealValue,
    this.createdAt,
  });

  double? get effectiveValue => dealValue ?? productPrice;

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

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  factory ConnectionEntity.fromJson(Map<String, dynamic> json) {
    final product = json['product'];

    return ConnectionEntity(
      id: json['id']?.toString(),
      clientId: _idOf(json['client_id'] ?? json['client']),
      clientName: _nameOf(json['client']) ?? json['client_name']?.toString(),
      productId: _idOf(json['product_id'] ?? product) ?? '',
      productName: _nameOf(product) ?? json['product_name']?.toString(),
      productPrice: product is Map
          ? _toDouble(product['price'])
          : _toDouble(json['product_price']),
      dealValue: _toDouble(json['deal_value']),
      stage: json['stage']?.toString() ?? ConnectionStage.lead,
      channelId: _idOf(json['channel_id'] ?? json['channel']),
      channelName: _nameOf(json['channel']) ?? json['channel_name']?.toString(),
      assigneeId: _idOf(json['assignee_id'] ?? json['assignee']),
      assigneeName:
          _nameOf(json['assignee']) ?? json['assignee_name']?.toString(),
      initiatedBy: json['initiated_by']?.toString(),
      campaignId: _idOf(json['campaign_id'] ?? json['campaign']),
      campaignName:
          _nameOf(json['campaign']) ?? json['campaign_name']?.toString(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'stage': stage,
      if (channelId != null && channelId!.trim().isNotEmpty)
        'channel_id': channelId,
      if (assigneeId != null && assigneeId!.trim().isNotEmpty)
        'assignee_id': assigneeId,
      if (initiatedBy != null && initiatedBy!.trim().isNotEmpty)
        'initiated_by': initiatedBy,
      if (campaignId != null && campaignId!.trim().isNotEmpty)
        'campaign_id': campaignId,
    };
  }

  ConnectionEntity copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? productId,
    String? productName,
    double? productPrice,
    double? dealValue,
    String? stage,
    String? channelId,
    String? channelName,
    String? assigneeId,
    String? assigneeName,
    String? initiatedBy,
    String? campaignId,
    String? campaignName,
    DateTime? createdAt,
  }) {
    return ConnectionEntity(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      dealValue: dealValue ?? this.dealValue,
      stage: stage ?? this.stage,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      assigneeId: assigneeId ?? this.assigneeId,
      assigneeName: assigneeName ?? this.assigneeName,
      initiatedBy: initiatedBy ?? this.initiatedBy,
      campaignId: campaignId ?? this.campaignId,
      campaignName: campaignName ?? this.campaignName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
