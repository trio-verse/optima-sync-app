import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:optima_sync_v2/app/domain/entities/public_capture_form_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';

class PublicCaptureRemoteDataSource {
  final http.Client client;

  PublicCaptureRemoteDataSource({required this.client});

  Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return json;
  }

  Future<PublicCaptureFormEntity> getForm(String token) async {
    final res = await client.get(
      Uri.parse("${ApiConstants.baseUrl}/capture/$token"),
      headers: const {"Accept": "application/json"},
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return PublicCaptureFormEntity.fromJson(_unwrap(json));
    }

    throw Exception("${res.statusCode} ${res.body}");
  }

  Future<void> submitForm({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final res = await client.post(
      Uri.parse("${ApiConstants.baseUrl}/capture/$token"),
      headers: const {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return;
    }

    throw Exception("${res.statusCode} ${res.body}");
  }
}
