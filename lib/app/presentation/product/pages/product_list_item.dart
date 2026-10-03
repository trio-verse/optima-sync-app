import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/pages/delete_product_dialog.dart';
import 'package:optima_sync_v2/app/presentation/product/pages/edit_product_form.dart';
import 'package:optima_sync_v2/app/presentation/product/theme/product_colors.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity product;

  const ProductListItem({super.key, required this.product});

  void _openEditProductForm(BuildContext context) {
    final bloc = context.read<ProductBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: bloc,
          child: EditProductForm(product: product),
        );
      },
    );
  }

  void _deleteProduct(BuildContext context) {
    showDeleteProductDialog(context: context, productId: product.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProductColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ProductColors.productIconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: ProductColors.productIconFg,
                  size: 20,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ProductColors.priceBadgeBg,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: ProductColors.priceBadgeFg,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: ProductColors.titleText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: ProductColors.subtitleText,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: ProductColors.cardBorder),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 19,
                  color: ProductColors.subtitleText,
                ),
                onPressed: () {
                  _openEditProductForm(context);
                },
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 19,
                  color: ProductColors.danger,
                ),
                onPressed: () {
                  _deleteProduct(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
