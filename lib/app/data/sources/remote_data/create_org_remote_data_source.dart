import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';

class CreateOrgRemoteDataSource {
  final http.Client client;

  CreateOrgRemoteDataSource({required this.client});

  Future<int> createOrg({
    required String token,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String description,
  }) async {
    // print(Uri.parse("${ApiConstants.baseUrl}/api/v1/organizations"));

    // print("Token: $token");

    final body = {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "description": description,
    };

    // print({
    //   "Authorization": "Bearer $token",
    //   "Content-Type": "application/json",
    //   "Accept": "application/json",
    // });

    final response = await client.post(
      Uri.parse("${ApiConstants.baseUrl}/api/v1/organizations"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );
    if (response.statusCode != 201) {
      throw Exception(response.body);
    }

    final json = jsonDecode(response.body);

    return json["data"]["id"];
  }

  Future<void> uploadLogo({
    required String token,
    required int organizationId,
    required XFile image,
  }) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "${ApiConstants.baseUrl}/api/v1/organizations/$organizationId/logo",
      ),
    );

    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    if (kIsWeb) {
      final bytes = await image.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes("logo", bytes, filename: image.name),
      );
    } else {
      final mimeType = lookupMimeType(image.path)?.split("/");

      request.files.add(
        await http.MultipartFile.fromPath(
          "logo",
          image.path,
          contentType: mimeType != null
              ? MediaType(mimeType[0], mimeType[1])
              : null,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Upload Logo Failed");
    }
  }
}
