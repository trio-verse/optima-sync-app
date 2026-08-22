const List<String> kClientTypes = [
  'company',
  'individual',
  'government',
  'charity',
  'agency',
];

class ClientEntity {
  final String? id;
  final String name;
  final String clientType;
  final int industryId;
  final int cityId;
  final String phone;
  final String? email;
  final String? address;
  final String? whatsapp;
  final String? facebook;
  final String? instagram;
  final String? website;
  final String? notes;

  final String? industryName;
  final String? cityName;

  ClientEntity({
    this.id,
    required this.name,
    required this.clientType,
    required this.industryId,
    required this.cityId,
    required this.phone,
    this.email,
    this.address,
    this.whatsapp,
    this.facebook,
    this.instagram,
    this.website,
    this.notes,
    this.industryName,
    this.cityName,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is Map) return _toInt(value['id']);
    return int.tryParse(value.toString());
  }

  static String? _nestedName(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value['name']?.toString();
    }
    return null;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return null;
  }

  factory ClientEntity.fromJson(Map<String, dynamic> json) {
    return ClientEntity(
      id: json['id']?.toString(),
      name: _asString(json['name']) ?? '',
      clientType: _asString(json['client_type']) ?? '',
      industryId: _toInt(json['industry_id'] ?? json['industry']?['id']) ?? 0,
      cityId: _toInt(json['city_id'] ?? json['city']?['id']) ?? 0,
      phone: _asString(json['phone']) ?? '',
      email: _asString(json['email']),
      address: _asString(json['address']),
      whatsapp: _asString(json['whatsapp']),
      facebook: _asString(json['facebook']),
      instagram: _asString(json['instagram']),
      website: _asString(json['website']),
      notes: _asString(json['notes']),
      industryName: _nestedName(json['industry']),
      cityName: _nestedName(json['city']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "client_type": clientType,
      "industry_id": industryId,
      "city_id": cityId,
      "phone": phone,
      if (email != null && email!.trim().isNotEmpty) "email": email,
      if (address != null && address!.trim().isNotEmpty) "address": address,
      if (whatsapp != null && whatsapp!.trim().isNotEmpty) "whatsapp": whatsapp,
      if (facebook != null && facebook!.trim().isNotEmpty) "facebook": facebook,
      if (instagram != null && instagram!.trim().isNotEmpty)
        "instagram": instagram,
      if (website != null && website!.trim().isNotEmpty) "website": website,
      if (notes != null && notes!.trim().isNotEmpty) "notes": notes,
    };
  }

  ClientEntity copyWith({
    String? id,
    String? name,
    String? clientType,
    int? industryId,
    int? cityId,
    String? phone,
    String? email,
    String? address,
    String? whatsapp,
    String? facebook,
    String? instagram,
    String? website,
    String? notes,
  }) {
    return ClientEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      clientType: clientType ?? this.clientType,
      industryId: industryId ?? this.industryId,
      cityId: cityId ?? this.cityId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      whatsapp: whatsapp ?? this.whatsapp,
      facebook: facebook ?? this.facebook,
      instagram: instagram ?? this.instagram,
      website: website ?? this.website,
      notes: notes ?? this.notes,
      industryName: industryName,
      cityName: cityName,
    );
  }
}

class ClientFilter {
  final String name;
  final String contactInfo;
  final int? cityId;
  final int? industryId;
  final String? clientType;
  final int perPage;
  final int page;

  const ClientFilter({
    this.name = '',
    this.contactInfo = '',
    this.cityId,
    this.industryId,
    this.clientType,
    this.perPage = 20,
    this.page = 1,
  });

  bool get isEmpty =>
      name.trim().isEmpty &&
      contactInfo.trim().isEmpty &&
      cityId == null &&
      industryId == null &&
      (clientType == null || clientType!.isEmpty);

  ClientFilter copyWith({
    String? name,
    String? contactInfo,
    int? cityId,
    bool clearCityId = false,
    int? industryId,
    bool clearIndustryId = false,
    String? clientType,
    bool clearClientType = false,
    int? perPage,
    int? page,
  }) {
    return ClientFilter(
      name: name ?? this.name,
      contactInfo: contactInfo ?? this.contactInfo,
      cityId: clearCityId ? null : (cityId ?? this.cityId),
      industryId: clearIndustryId ? null : (industryId ?? this.industryId),
      clientType: clearClientType ? null : (clientType ?? this.clientType),
      perPage: perPage ?? this.perPage,
      page: page ?? this.page,
    );
  }

  Map<String, String> toQueryParameters() {
    final params = <String, String>{
      "per_page": perPage.toString(),
      "page": page.toString(),
    };

    if (name.trim().isNotEmpty) {
      params["search[name]"] = name.trim();
    }

    if (contactInfo.trim().isNotEmpty) {
      params["search[contact_info]"] = contactInfo.trim();
    }

    if (cityId != null) {
      params["city_id"] = cityId.toString();
    }

    if (industryId != null) {
      params["industry_id"] = industryId.toString();
    }

    if (clientType != null && clientType!.isNotEmpty) {
      params["client_type"] = clientType!;
    }

    return params;
  }
}

class ClientListResult {
  final List<ClientEntity> clients;
  final int currentPage;
  final int lastPage;

  const ClientListResult({
    required this.clients,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasMore => currentPage < lastPage;
}
