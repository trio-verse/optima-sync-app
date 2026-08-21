import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/pages/delete_product_dialog.dart';
import 'package:optima_sync_v2/app/presentation/product/pages/edit_product_form.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity product;

  const ProductListItem({super.key, required this.product});

  void _openEditProductForm(BuildContext context) {
    final bloc = context.read<ProductBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
    return ListTile(
      // leading: const Icon(Icons.inventory_2_outlined),
      title: Text(product.name),

      subtitle: Text(
        product.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            product.price.toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),

          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              _openEditProductForm(context);
            },
          ),

          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _deleteProduct(context);
            },
          ),
        ],
      ),
    );
  }
}
