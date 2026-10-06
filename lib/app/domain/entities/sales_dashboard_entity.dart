import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';

class DashboardBreakdownItem {
  final String label;
  final int count;

  const DashboardBreakdownItem({required this.label, required this.count});
}

class DashboardTopProduct {
  final String productId;
  final String name;
  final double price;
  final int deals;
  final int clients;

  const DashboardTopProduct({
    required this.productId,
    required this.name,
    required this.price,
    required this.deals,
    required this.clients,
  });
}

class SalesDashboardEntity {
  final int totalClients;
  final int totalConnections;
  final int totalProducts;
  final int citiesCovered;
  final int wonConnections;
  final double wonRevenue;
  final Map<String, int> stageCounts;
  final List<DashboardTopProduct> topProducts;
  final List<DashboardBreakdownItem> clientsByCity;
  final List<DashboardBreakdownItem> clientsByIndustry;
  final List<ConnectionEntity> recentConnections;

  const SalesDashboardEntity({
    required this.totalClients,
    required this.totalConnections,
    required this.totalProducts,
    required this.citiesCovered,
    required this.wonConnections,
    required this.wonRevenue,
    required this.stageCounts,
    required this.topProducts,
    required this.clientsByCity,
    required this.clientsByIndustry,
    required this.recentConnections,
  });

  double get winRate {
    if (totalConnections == 0) return 0;
    return (wonConnections / totalConnections) * 100;
  }
}
