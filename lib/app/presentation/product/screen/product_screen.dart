import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_event.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_state.dart';
import 'package:optima_sync_v2/app/presentation/product/pages/add_product_form.dart';
import 'package:optima_sync_v2/app/presentation/product/pages/product_list_item.dart';
import 'package:optima_sync_v2/app/presentation/product/theme/product_colors.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final searchController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(LoadProducts());

    searchController.addListener(() {
      setState(() {
        query = searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _openAddProductForm() {
    final bloc = context.read<ProductBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider.value(value: bloc, child: const AddProductForm());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProductColors.background,
      body: SafeArea(
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductInitial || state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductFailure && state.products == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: ProductColors.bodyText),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ProductColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          context.read<ProductBloc>().add(LoadProducts());
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final products = state is ProductSuccess
                ? state.products
                : (state as ProductFailure).products ?? [];

            final filtered = query.isEmpty
                ? products
                : products.where((p) {
                    return p.name.toLowerCase().contains(query) ||
                        p.description.toLowerCase().contains(query);
                  }).toList();

            final totalProducts = products.length;
            final totalPrices = products.fold<double>(
              0,
              (sum, p) => sum + p.price,
            );

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductBloc>().add(LoadProducts());
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _HeaderCard(onAddProduct: _openAddProductForm),
                  const SizedBox(height: 16),
                  _StatsRow(
                    totalProducts: totalProducts,
                    totalPrices: totalPrices,
                  ),
                  const SizedBox(height: 16),
                  _SearchField(controller: searchController),
                  const SizedBox(height: 16),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          "No products yet",
                          style: TextStyle(color: ProductColors.subtitleText),
                        ),
                      ),
                    )
                  else
                    ...filtered.map(
                      (product) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProductListItem(product: product),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final VoidCallback onAddProduct;

  const _HeaderCard({required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ProductColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ProductColors.cardBorder),
        boxShadow: [ProductColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: ProductColors.heroIconGradient,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Flexible(
                          child: Text(
                            "Products & Services",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: ProductColors.titleText,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: ProductColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Manage all available products to link them with deals and clients.",
                      style: TextStyle(
                        fontSize: 13,
                        color: ProductColors.subtitleText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: ProductColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                "Add New Product",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int totalProducts;
  final double totalPrices;

  const _StatsRow({required this.totalProducts, required this.totalPrices});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: "TOTAL PRODUCTS",
            value: "$totalProducts",
            icon: Icons.layers_outlined,
            iconBg: ProductColors.statBlueBg,
            iconFg: ProductColors.statBlueFg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: "TOTAL PRICES",
            value: "\$${totalPrices.toStringAsFixed(2)}",
            icon: Icons.attach_money,
            iconBg: ProductColors.statGreenBg,
            iconFg: ProductColors.statGreenFg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: "STATUS",
            value: "Active",
            valueColor: ProductColors.statGreenFg,
            icon: Icons.show_chart,
            iconBg: ProductColors.statPurpleBg,
            iconFg: ProductColors.statPurpleFg,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData icon;
  final Color iconBg;
  final Color iconFg;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ProductColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProductColors.cardBorder),
        boxShadow: [ProductColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconFg, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: ProductColors.subtitleText,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? ProductColors.titleText,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Search by product name or description...",
        hintStyle: const TextStyle(
          color: ProductColors.subtitleText,
          fontSize: 13,
        ),
        prefixIcon: const Icon(Icons.search, color: ProductColors.subtitleText),
        filled: true,
        fillColor: ProductColors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: ProductColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: ProductColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: ProductColors.primary),
        ),
      ),
    );
  }
}
