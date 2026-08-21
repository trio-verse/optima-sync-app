import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_event.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_state.dart';

void showDeleteProductDialog({
  required BuildContext context,
  required String productId,
}) {
  final bloc = context.read<ProductBloc>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: bloc,
        child: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductSuccess) {
              Navigator.pop(dialogContext);
            }

            if (state is ProductFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              final isDeleting = state is ProductLoading;

              return AlertDialog(
                title: const Text("Delete Product"),

                content: const Text(
                  "Are you sure you want to delete this product?",
                ),

                actions: [
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () {
                            Navigator.pop(dialogContext);
                          },
                    child: const Text("Cancel"),
                  ),

                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () {
                            context.read<ProductBloc>().add(
                              DeleteProductSubmitted(id: productId),
                            );
                          },
                    child: isDeleting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Confirm"),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
