const List<String> kProjectStatuses = [
  'new',
  'under_review',
  'accepted',
  'in_progress',
  'on_hold',
  'completed',
  'rejected',
  'fail',
  'deliverd',
];

class ProjectEntity {
  final String id;
  final String referenceNumber;
  final String title;
  final String status;
  final String? clientName;
  final String? industryName;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final String? description;
  final String? duration;
  final String? clientId;
  final double subTotal;
  final double profitPercentage;
  final double totalAmount;
  final double discount;
  final double tax;
  final DateTime? issueDate;
  final DateTime? validUntil;
  final String? paymentTerms;
  final String? currentVersionId;

  ProjectEntity({
    required this.id,
    required this.referenceNumber,
    required this.title,
    required this.status,
    this.clientName,
    this.industryName,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.description,
    this.duration,
    this.clientId,
    this.subTotal = 0,
    this.profitPercentage = 0,
    this.totalAmount = 0,
    this.discount = 0,
    this.tax = 0,
    this.issueDate,
    this.validUntil,
    this.paymentTerms,
    this.currentVersionId,
  });

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

  static Map<String, dynamic>? _versionMap(Map<String, dynamic> json) {
    for (final key in const [
      'current_version',
      'currentVersion',
      'active_version',
      'latest_version',
      'version',
    ]) {
      final value = json[key];
      if (value is Map) return Map<String, dynamic>.from(value);
    }
    final versions = json['versions'];
    if (versions is List && versions.isNotEmpty && versions.first is Map) {
      return Map<String, dynamic>.from(versions.first as Map);
    }
    return null;
  }

  static String? _firstText(List<dynamic> candidates) {
    for (final value in candidates) {
      final text = _asString(value)?.trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }

  static String? _nestedName(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value['name']?.toString();
    }
    return null;
  }

  factory ProjectEntity.fromJson(Map<String, dynamic> json) {
    final version = _versionMap(json);
    return ProjectEntity(
      id: json['id']?.toString() ?? '',
      referenceNumber: _asString(json['reference_number']) ?? '',
      title:
          _firstText([
            json['title'],
            json['name'],
            json['project_title'],
            version?['title'],
          ]) ??
          '',
      status: _asString(json['status']) ?? 'new',
      clientName: _asString(json['client_name']) ?? _nestedName(json['client']),
      industryName:
          _asString(json['industry_name']) ?? _nestedName(json['industry']),
      startDate: _asDate(json['start_date'] ?? version?['start_date']),
      endDate: _asDate(json['end_date'] ?? version?['end_date']),
      createdAt: _asDate(json['created_at']),
      description: _firstText([json['description'], version?['description']]),
      duration: _firstText([json['duration'], version?['duration']]),
      clientId: _asString(
        json['client_id'] ??
            (json['client'] is Map ? json['client']['id'] : null),
      ),
      subTotal: double.tryParse('${json['sub_total'] ?? 0}') ?? 0,
      profitPercentage:
          double.tryParse('${json['profit_percentage'] ?? 0}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount'] ?? 0}') ?? 0,
      discount: double.tryParse('${json['discount'] ?? 0}') ?? 0,
      tax: double.tryParse('${json['tax'] ?? 0}') ?? 0,
      issueDate: _asDate(json['issue_date']),
      validUntil: _asDate(json['valid_until']),
      paymentTerms: _asString(json['payment_terms']),
      currentVersionId:
          _asString(json['current_version_id']) ?? _asString(version?['id']),
    );
  }
}

class ProjectInput {
  final String clientId;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? duration;
  final double subTotal;
  final double profitPercentage;
  final double discount;
  final double tax;
  final DateTime? issueDate;
  final DateTime? validUntil;
  final String? paymentTerms;

  const ProjectInput({
    required this.clientId,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    this.duration,
    this.subTotal = 0,
    this.profitPercentage = 0,
    this.discount = 0,
    this.tax = 0,
    this.issueDate,
    this.validUntil,
    this.paymentTerms,
  });

  double get calculatedTotal {
    final profit = subTotal * (profitPercentage / 100);
    final discountValue = subTotal * (discount / 100);
    final taxValue = subTotal * (tax / 100);
    return subTotal + profit - discountValue + taxValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': int.tryParse(clientId) ?? clientId,
      'title': title,
      'description': description,
      if (startDate != null) 'start_date': startDate!.toIso8601String(),
      if (endDate != null) 'end_date': endDate!.toIso8601String(),
      if (duration != null && duration!.isNotEmpty) 'duration': duration,
      'sub_total': subTotal,
      'profit_percentage': profitPercentage.round(),
      'total_amount': calculatedTotal,
      'discount': discount,
      'tax': tax,
      if (issueDate != null) 'issue_date': issueDate!.toIso8601String(),
      if (validUntil != null) 'valid_until': validUntil!.toIso8601String(),
      if (paymentTerms != null && paymentTerms!.isNotEmpty)
        'payment_terms': paymentTerms,
    };
  }
}

class ProjectUpdateInput {
  final String? versionId;
  final String clientId;
  final String title;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? duration;
  final double subTotal;
  final double profitPercentage;
  final double discount;
  final double tax;
  final DateTime? validUntil;
  final String? paymentTerms;

  const ProjectUpdateInput({
    required this.versionId,
    required this.clientId,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    this.duration,
    this.subTotal = 0,
    this.profitPercentage = 0,
    this.discount = 0,
    this.tax = 0,
    this.validUntil,
    this.paymentTerms,
  });

  double get calculatedTotal {
    final profit = subTotal * (profitPercentage / 100);
    final discountValue = subTotal * (discount / 100);
    final taxValue = subTotal * (tax / 100);
    return subTotal + profit - discountValue + taxValue;
  }

  Map<String, dynamic> toProjectJson() => {
    'client_id': int.tryParse(clientId) ?? clientId,
    'sub_total': subTotal,
    'profit_percentage': profitPercentage.round(),
    'total_amount': calculatedTotal,
    'discount': discount,
    'tax': tax,
    if (validUntil != null) 'valid_until': validUntil!.toIso8601String(),
    if (paymentTerms != null && paymentTerms!.isNotEmpty)
      'payment_terms': paymentTerms,
  };

  Map<String, dynamic> toVersionJson() => {
    'title': title,
    'description': description,
    if (startDate != null) 'start_date': startDate!.toIso8601String(),
    if (endDate != null) 'end_date': endDate!.toIso8601String(),
    if (duration != null && duration!.isNotEmpty) 'duration': duration,
  };
}

class ProjectClientOption {
  final String id;
  final String name;

  const ProjectClientOption({required this.id, required this.name});
}

class ProjectFilter {
  final String search;
  final String? status;
  final int perPage;
  final int page;

  const ProjectFilter({
    this.search = '',
    this.status,
    this.perPage = 20,
    this.page = 1,
  });

  bool get isEmpty =>
      search.trim().isEmpty && (status == null || status!.isEmpty);

  ProjectFilter copyWith({
    String? search,
    String? status,
    bool clearStatus = false,
    int? perPage,
    int? page,
  }) {
    return ProjectFilter(
      search: search ?? this.search,
      status: clearStatus ? null : (status ?? this.status),
      perPage: perPage ?? this.perPage,
      page: page ?? this.page,
    );
  }

  Map<String, String> toQueryParameters() {
    final params = <String, String>{
      "per_page": perPage.toString(),
      "page": page.toString(),
    };

    if (search.trim().isNotEmpty) {
      params["search"] = search.trim();
    }

    if (status != null && status!.isNotEmpty) {
      params["status"] = status!;
    }

    return params;
  }
}

class ProjectListResult {
  final List<ProjectEntity> projects;
  final int currentPage;
  final int lastPage;

  const ProjectListResult({
    required this.projects,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasMore => currentPage < lastPage;
}
