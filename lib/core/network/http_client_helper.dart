import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClientHelper {
  final SharedPreferences storage;
  final Client client;

  HttpClientHelper({required this.storage, required this.client});

  Future<String?> getToken() async {
    return storage.getString('Token');
  }

  Future<T?> post<T>(
    String url,
    Map<String, dynamic> body,
    T? Function(Map<String, dynamic> json) fromJson, {
    String? organizationId,
  }) async {
    print("================================");
    print("TOKEN: ${await getToken()}");
    print("ORGANIZATION ID: $organizationId");
    print("BODY: $body");
    print("================================");

    final res = await client.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Authorization': "Bearer ${await getToken()}",
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (organizationId != null) "X-Organization-Id": organizationId,
      },
    );

    if (res.statusCode == 201) {
      return fromJson(jsonDecode(res.body));
    } else {
      throw Exception("${res.statusCode} ${res.body}");
    }
  }

  Future<T?> get<T>(
    String url,
    T? Function(Map<String, dynamic> json) fromJson, {
    String? organizationId,
  }) async {
    print("================================");
    print("TOKEN: ${await getToken()}");
    print("ORGANIZATION ID: $organizationId");
    print("GET URL: $url");
    print("================================");

    final res = await client.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${await getToken()}",
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (organizationId != null) "X-Organization-Id": organizationId,
      },
    );

    if (res.statusCode == 200) {
      return fromJson(jsonDecode(res.body));
    } else {
      throw Exception("${res.statusCode} ${res.body}");
    }
  }

  Future<T?> patch<T>(
    String url,
    Map<String, dynamic> body,
    T? Function(Map<String, dynamic> json) fromJson, {
    String? organizationId,
  }) async {
    final res = await client.patch(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Authorization': "Bearer ${await getToken()}",
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (organizationId != null) "X-Organization-Id": organizationId,
      },
    );

    if (res.statusCode == 200) {
      return fromJson(jsonDecode(res.body));
    } else {
      throw Exception("${res.statusCode} ${res.body}");
    }
  }
}
