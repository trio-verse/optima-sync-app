import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:optima_sync_v2/app/presentation/product/bloc/product_bloc.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_event.dart';
import 'package:optima_sync_v2/app/presentation/product/bloc/product_state.dart';
import 'package:optima_sync_v2/app/presentation/product/theme/product_colors.dart';

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
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ProductColors.priceBadgeBg.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: ProductColors.danger,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Delete Product",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: ProductColors.titleText,
                        ),
                      ),
                    ),
                  ],
                ),
                content: const Text(
                  "Are you sure you want to delete this product? This action cannot be undone.",
                  style: TextStyle(color: ProductColors.subtitleText),
                ),
                actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                actions: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isDeleting
                          ? null
                          : () {
                              Navigator.pop(dialogContext);
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ProductColors.titleText,
                        side: const BorderSide(
                          color: ProductColors.inputBorder,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isDeleting
                          ? null
                          : () {
                              context.read<ProductBloc>().add(
                                DeleteProductSubmitted(id: productId),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProductColors.danger,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isDeleting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Confirm"),
                    ),
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
