abstract class ApiPaths {
  static const String baseUrl = "https://optima.trio-verse.com";
  static const String campaigns = "${ApiPaths.baseUrl}/api/v1/campaigns";
  static String campaignEdit(String id) => "${ApiPaths.baseUrl}/api/v1/campaigns/$id";
  static String contentEdit(String campaignId, String contentId) =>
      "${ApiPaths.baseUrl}/api/v1/campaigns/$campaignId/contents/$contentId";
}
