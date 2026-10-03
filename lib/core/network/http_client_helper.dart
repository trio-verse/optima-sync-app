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
    List<int> acceptedStatusCodes = const [201],
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

    if (acceptedStatusCodes.contains(res.statusCode)) {
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
    print("GET REQUEST");
    print("URL: $url");
    print("TOKEN EXISTS: ${(await getToken()) != null}");
    print("ORGANIZATION ID: $organizationId");
    print("================================");

    try {
      print(">>> Sending GET request...");

      final res = await client.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${await getToken()}",
          "Content-Type": "application/json",
          "Accept": "application/json",
          if (organizationId != null) "X-Organization-Id": organizationId,
        },
      );

      print(">>> GET request completed");

      print("========== HTTP GET RESPONSE ==========");
      print("URL: $url");
      print("STATUS CODE: ${res.statusCode}");
      print("RESPONSE BODY: ${res.body}");
      print("RESPONSE HEADERS: ${res.headers}");
      print("========================================");

      if (res.statusCode == 200) {
        print(">>> Status 200 - Parsing JSON...");

        final json = jsonDecode(res.body);

        print("========== PARSED JSON ==========");
        print(json);
        print("=================================");

        return fromJson(json);
      } else {
        print("========== HTTP ERROR ==========");
        print("STATUS CODE: ${res.statusCode}");
        print("BODY: ${res.body}");
        print("===============================");

        throw Exception("${res.statusCode} ${res.body}");
      }
    } catch (e, stackTrace) {
      print("========== REQUEST EXCEPTION ==========");
      print("Exception Type: ${e.runtimeType}");
      print("Exception: $e");
      print("StackTrace: $stackTrace");
      print("========================================");

      rethrow;
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

  Future<void> delete(String url, {String? organizationId}) async {
    final res = await client.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${await getToken()}",
        "Content-Type": "application/json",
        "Accept": "application/json",
        if (organizationId != null) "X-Organization-Id": organizationId,
      },
    );

    if (res.statusCode == 200 || res.statusCode == 204) {
      return;
    } else {
      throw Exception("${res.statusCode} ${res.body}");
    }
  }

  Future<String> getText(String url, {String? organizationId}) async {
    final res = await client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Accept': 'text/html, application/json',
        if (organizationId != null) 'X-Organization-Id': organizationId,
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body;
    }
    throw Exception('${res.statusCode} ${res.body}');
  }

  Future<String> postText(
    String url, {
    String? organizationId,
    Map<String, dynamic> body = const {},
  }) async {
    final res = await client.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json',
        'Accept': 'application/json, application/pdf',
        if (organizationId != null) 'X-Organization-Id': organizationId,
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body;
    }
    throw Exception('${res.statusCode} ${res.body}');
  }
}
