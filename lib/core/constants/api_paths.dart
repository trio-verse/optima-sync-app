abstract class ApiPaths {
  static const String baseUrl = "https://optima.trio-verse.com";
  static const String campaigns = "${ApiPaths.baseUrl}/api/v1/campaigns";
  static String campaignEdit(String id) => "${ApiPaths.baseUrl}/api/v1/campaigns/$id";
}
