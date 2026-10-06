class CaptureSettingsEntity {
  final bool enabled;
  final String? link;
  final String? qrCode;
  final String? token;
  final Map<String, dynamic> raw;

  const CaptureSettingsEntity({
    this.enabled = false,
    this.link,
    this.qrCode,
    this.token,
    this.raw = const {},
  });

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  factory CaptureSettingsEntity.fromJson(Map<String, dynamic> json) {
    return CaptureSettingsEntity(
      enabled: _toBool(json['enabled'] ?? json['is_enabled']),
      link: _asString(
        json['link'] ?? json['capture_link'] ?? json['url'] ?? json['form_url'],
      ),
      qrCode: _asString(
        json['qr_code'] ?? json['qr_code_data'] ?? json['qrCode'] ?? json['qr'],
      ),
      token: _asString(json['token']),
      raw: json,
    );
  }

  CaptureSettingsEntity copyWith({bool? enabled}) {
    return CaptureSettingsEntity(
      enabled: enabled ?? this.enabled,
      link: link,
      qrCode: qrCode,
      token: token,
      raw: raw,
    );
  }
}
