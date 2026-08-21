import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_event.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_state.dart';
import 'package:optima_sync_v2/app/presentation/product/pages/add_product_form.dart';
import 'package:optima_sync_v2/app/presentation/product/pages/product_list_item.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(LoadProducts());
  }

  void _openAddProductForm() {
    final bloc = context.read<ProductBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(value: bloc, child: const AddProductForm());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddProductForm,
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
      ),

      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
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

          if (state is ProductSuccess) {
            if (state.products.isEmpty) {
              return const Center(child: Text("No products yet"));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.products.length,
              separatorBuilder: (_, __) {
                return const Divider(height: 1);
              },
              itemBuilder: (context, index) {
                return ProductListItem(product: state.products[index]);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
