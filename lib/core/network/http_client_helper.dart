import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:optima_sync_v2/core/errors/exceptions/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClientHelper {
  final SharedPreferences storage;
  final Client client;

  HttpClientHelper({required this.storage, required this.client});

  Future<String?> getToken() async {
    return storage.getString('Token');
  }

  Future<Response> _send(Future<Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 15));
    } on SocketException {
      throw const OfflineException();
    } on ClientException {
      throw const OfflineException();
    } on TimeoutException {
      throw const OfflineException();
    }
  }

  Never _throwForStatus(Response res) {
    switch (res.statusCode) {
      case 204:
        throw const NoContentException();
      case 400 || 422:
        throw BadRequestException(res.body);
      case 401:
        throw const UnauthorizedException();
      case 404:
        throw const NotFoundException();
      default:
        throw ServerException(res.statusCode);
    }
  }

  Future<T?> post<T>(
    String url,
    Map<String, dynamic> body,
    T? Function(Map<String, dynamic> json) fromJson, {
    String? organizationId,
    List<int> acceptedStatusCodes = const [201],
  }) async {
    final token = await getToken();
    final res = await _send(
      () => client.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (organizationId != null) 'X-Organization-Id': organizationId,
        },
      ),
    );

    if (acceptedStatusCodes.contains(res.statusCode)) {
      return fromJson(jsonDecode(res.body));
    }
    _throwForStatus(res);
  }

  Future<T?> get<T>(
    String url,
    T? Function(Map<String, dynamic> json) fromJson, {
    String? organizationId,
  }) async {
    final token = await getToken();
    final res = await _send(
      () => client.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (organizationId != null) 'X-Organization-Id': organizationId,
        },
      ),
    );

    if (res.statusCode == 200) {
      return fromJson(jsonDecode(res.body));
    }
    _throwForStatus(res);
  }

  Future<T?> patch<T>(
    String url,
    Map<String, dynamic> body,
    T? Function(Map<String, dynamic> json) fromJson, {
    String? organizationId,
  }) async {
    final token = await getToken();
    final res = await _send(
      () => client.patch(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (organizationId != null) 'X-Organization-Id': organizationId,
        },
      ),
    );

    if (res.statusCode == 200) {
      return fromJson(jsonDecode(res.body));
    }
    _throwForStatus(res);
  }

  Future<void> delete(String url, {String? organizationId}) async {
    final token = await getToken();
    final res = await _send(
      () => client.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (organizationId != null) 'X-Organization-Id': organizationId,
        },
      ),
    );

    if (res.statusCode == 200 || res.statusCode == 204) return;
    _throwForStatus(res);
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
