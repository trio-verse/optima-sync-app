import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/city_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/client_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/connection_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/industry_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/domain/entities/sales_dashboard_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/city_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/client_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/connection_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/industry_usecases.dart';
import 'package:optima_sync_v2/app/domain/usecases/product_usecases.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ConnectionUsecases connectionUsecases;
  final ClientUsecases clientUsecases;
  final ProductUsecases productUsecases;
  final CityUsecases cityUsecases;
  final IndustryUsecases industryUsecases;

  HomeBloc({
    required this.connectionUsecases,
    required this.clientUsecases,
    required this.productUsecases,
    required this.cityUsecases,
    required this.industryUsecases,
  }) : super(const HomeInitial()) {
    on<LoadHomeDashboard>(_onLoadHomeDashboard);
  }

  Future<void> _onLoadHomeDashboard(
    LoadHomeDashboard event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      final connectionsFuture = _loadConnections();
      final clientsFuture = _loadAllClients();
      final productsFuture = _loadProducts();
      final citiesFuture = _loadCities();
      final industriesFuture = _loadIndustries();

      final connections = await connectionsFuture;
      final clients = await clientsFuture;
      final products = await productsFuture;
      final cities = await citiesFuture;
      final industries = await industriesFuture;

      if (connections == null || clients == null || products == null) {
        emit(
          const HomeFailure(
            message: 'Unable to load dashboard data. Please try again.',
          ),
        );
        return;
      }

      emit(
        HomeSuccess(
          dashboard: _buildDashboard(
            connections: connections,
            clients: clients,
            products: products,
            cities: cities ?? const [],
            industries: industries ?? const [],
          ),
        ),
      );
    } catch (_) {
      emit(
        const HomeFailure(
          message: 'Unable to load dashboard data. Please try again.',
        ),
      );
    }
  }

  Future<List<ConnectionEntity>?> _loadConnections() async {
    final result = await connectionUsecases.getAllConnections();
    return result.fold((_) => null, (value) => value);
  }

  Future<List<ProductEntity>?> _loadProducts() async {
    final result = await productUsecases.getProducts();
    return result.fold((_) => null, (value) => value);
  }

  Future<List<CityEntity>?> _loadCities() async {
    final result = await cityUsecases.getCities();
    return result.fold((_) => null, (value) => value);
  }

  Future<List<IndustryEntity>?> _loadIndustries() async {
    final result = await industryUsecases.getIndustries();
    return result.fold((_) => null, (value) => value);
  }

  Future<List<ClientEntity>?> _loadAllClients() async {
    final allClients = <ClientEntity>[];
    var page = 1;
    var hasMore = true;

    while (hasMore && page <= 100) {
      final result = await clientUsecases.getClients(
        ClientFilter(perPage: 100, page: page),
      );

      final pageResult = result.fold<ClientListResult?>(
        (_) => null,
        (value) => value,
      );

      if (pageResult == null) return null;

      allClients.addAll(pageResult.clients);
      hasMore = pageResult.hasMore;
      page = pageResult.currentPage + 1;
    }

    return allClients;
  }

  SalesDashboardEntity _buildDashboard({
    required List<ConnectionEntity> connections,
    required List<ClientEntity> clients,
    required List<ProductEntity> products,
    required List<CityEntity> cities,
    required List<IndustryEntity> industries,
  }) {
    final stageCounts = <String, int>{
      for (final stage in ConnectionStage.values) stage: 0,
    };

    for (final connection in connections) {
      stageCounts[connection.stage] = (stageCounts[connection.stage] ?? 0) + 1;
    }

    final productsById = <String, ProductEntity>{
      for (final product in products)
        if (product.id != null) product.id!: product,
    };

    final topProductStats = <String, _ProductStats>{};
    var wonRevenue = 0.0;

    for (final connection in connections) {
      final product = productsById[connection.productId];
      final productName = connection.productName ?? product?.name ?? 'Product';
      final productPrice = connection.productPrice ?? product?.price ?? 0;
      final stats = topProductStats.putIfAbsent(
        connection.productId,
        () => _ProductStats(name: productName, price: productPrice),
      );

      stats.deals += 1;
      if (connection.clientId != null) {
        stats.clientIds.add(connection.clientId!);
      }

      if (connection.stage == ConnectionStage.won) {
        wonRevenue += connection.effectiveValue ?? product?.price ?? 0;
      }
    }

    final topProducts =
        topProductStats.entries
            .map(
              (entry) => DashboardTopProduct(
                productId: entry.key,
                name: entry.value.name,
                price: entry.value.price,
                deals: entry.value.deals,
                clients: entry.value.clientIds.length,
              ),
            )
            .toList()
          ..sort((a, b) => b.deals.compareTo(a.deals));

    final clientsByCityMap = <String, int>{};
    final clientsByIndustryMap = <String, int>{};
    final cityIds = <int>{};
    final cityNamesById = <String, String>{
      for (final city in cities)
        if (city.id != null) city.id!: city.name,
    };
    final industryNamesById = <String, String>{
      for (final industry in industries)
        if (industry.id != null) industry.id!: industry.name,
    };

    for (final client in clients) {
      final cityLabel = (client.cityName?.trim().isNotEmpty ?? false)
          ? client.cityName!.trim()
          : cityNamesById[client.cityId.toString()] ??
                (client.cityId > 0 ? 'City ${client.cityId}' : 'Unknown');
      final industryLabel = (client.industryName?.trim().isNotEmpty ?? false)
          ? client.industryName!.trim()
          : industryNamesById[client.industryId.toString()] ??
                (client.industryId > 0
                    ? 'Industry ${client.industryId}'
                    : 'Unknown');

      clientsByCityMap[cityLabel] = (clientsByCityMap[cityLabel] ?? 0) + 1;
      clientsByIndustryMap[industryLabel] =
          (clientsByIndustryMap[industryLabel] ?? 0) + 1;

      if (client.cityId > 0) cityIds.add(client.cityId);
    }

    List<DashboardBreakdownItem> toBreakdown(Map<String, int> source) {
      final items = source.entries
          .map(
            (entry) =>
                DashboardBreakdownItem(label: entry.key, count: entry.value),
          )
          .toList();
      items.sort((a, b) => b.count.compareTo(a.count));
      return items;
    }

    final recentConnections = [...connections]
      ..sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

    return SalesDashboardEntity(
      totalClients: clients.length,
      totalConnections: connections.length,
      totalProducts: products.length,
      citiesCovered: cityIds.length,
      wonConnections: stageCounts[ConnectionStage.won] ?? 0,
      wonRevenue: wonRevenue,
      stageCounts: stageCounts,
      topProducts: topProducts.take(5).toList(),
      clientsByCity: toBreakdown(clientsByCityMap),
      clientsByIndustry: toBreakdown(clientsByIndustryMap),
      recentConnections: recentConnections.take(5).toList(),
    );
  }
}

class _ProductStats {
  final String name;
  final double price;
  int deals = 0;
  final Set<String> clientIds = {};

  _ProductStats({required this.name, required this.price});
}
