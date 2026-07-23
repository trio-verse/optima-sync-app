import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:optima_sync_v2/core/constants/api_constant.dart';

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource({required this.client});

  Future<void> signUp(String email) async {
    final response = await client.post(
      Uri.parse("${ApiConstants.baseUrl}/api/v1/register-email"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode != 201) {
      throw Exception("Status Code: ${response.statusCode}\n${response.body}");
    }
  }

  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    final response = await client.post(
      Uri.parse("${ApiConstants.baseUrl}/api/v1/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": code}),
    );
    print('--------------------------------');
    print('response: ${response.body}!');
    print('--------------------------------');

    final resMap = jsonDecode(response.body) as Map<String, dynamic>;
    final token = resMap['data']['token'];
    print("token: $token");
    if (response.statusCode != 200) {
      throw Exception("Verification failed");
    }
    return token;
  }
}
