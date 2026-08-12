import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:optima_sync_v2/app/data/sources/local_data/auth_local_data_source.dart';
import 'package:optima_sync_v2/app/domain/entities/org_entity.dart';
import 'package:optima_sync_v2/core/constants/api_constant.dart';
import 'package:optima_sync_v2/core/network/http_client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrgRemoteDataSource {
  final HttpClientHelper client;
  CreateOrgRemoteDataSource({required this.client});

  Future<String> createOrg(OrgEntity org) async {
    print(org.toJson());
    final res = await client.post<String>(
      "${ApiConstants.baseUrl}/api/v1/organizations",
      org.toJson(),
      (json) {
        print(json);
        return json['data']['id'].toString();
      },
    );

    return res!;
  }

  Future<void> uploadLogo({
    required String organizationId,
    required XFile image,
  }) async {
    final token = await client.getToken();

    print("================================");
    print("TOKEN: $token");
    print("================================");
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "${ApiConstants.baseUrl}/api/v1/organizations/$organizationId/logo",
      ),
    );

    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    request.files.add(await http.MultipartFile.fromPath("logo", image.path));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Upload Logo Failed");
    }
  }

  Future<void> selectOrganization({required String organizationId}) async {
    await client.post<void>(
      "${ApiConstants.baseUrl}/api/v1/organizations/myOrgs",
      {"organization_id": organizationId},
      (json) => null,
    );
  }

  Future<List<OrgEntity>> getOrganizations() async {
    final result = await client.get<List<OrgEntity>>(
      "${ApiConstants.baseUrl}/api/v1/organizations",
      (json) {
        return (json["data"] as List)
            .map((e) => OrgEntity.fromJson(e))
            .toList();
      },
    );

    return result!;
  }
}
