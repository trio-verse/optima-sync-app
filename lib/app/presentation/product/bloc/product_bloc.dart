import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/product_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductUsecases usecases;

  ProductBloc({required this.usecases}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProductSubmitted>(_onAddProductSubmitted);
    on<UpdateProductSubmitted>(_onUpdateProductSubmitted);
    on<DeleteProductSubmitted>(_onDeleteProductSubmitted);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await usecases.getProducts();

    result.fold(
      (failure) => emit(ProductFailure(message: _messageFor(failure))),
      (products) => emit(ProductSuccess(products: products)),
    );
  }

  Future<void> _onAddProductSubmitted(
    AddProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final name = event.name.trim();

    if (name.isEmpty) {
      emit(const ProductFailure(message: 'Product name cannot be empty'));
      return;
    }

    final createResult = await usecases.createProduct(
      name: name,
      price: event.price,
      description: event.description.trim(),
    );

    await createResult.fold(
      (failure) async => emit(ProductFailure(message: _messageFor(failure))),
      (created) async {
        final refreshResult = await usecases.getProducts();

        final products = refreshResult.fold((_) {
          final previous = state is ProductSuccess
              ? (state as ProductSuccess).products
              : <ProductEntity>[];
          return [...previous, created];
        }, (list) => list);

        emit(ProductSuccess(products: products));
      },
    );
  }

  Future<void> _onUpdateProductSubmitted(
    UpdateProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final name = event.name.trim();

    if (name.isEmpty) {
      emit(const ProductFailure(message: 'Product name cannot be empty'));
      return;
    }

    final updateResult = await usecases.updateProduct(
      id: event.id,
      name: name,
      price: event.price,
      description: event.description.trim(),
    );

    await updateResult.fold(
      (failure) async => emit(ProductFailure(message: _messageFor(failure))),
      (updated) async {
        final refreshResult = await usecases.getProducts();

        final products = refreshResult.fold((_) {
          final previous = state is ProductSuccess
              ? (state as ProductSuccess).products
              : <ProductEntity>[];
          return [
            for (final p in previous)
              if (p.id == updated.id) updated else p,
          ];
        }, (list) => list);

        emit(ProductSuccess(products: products));
      },
    );
  }

  Future<void> _onDeleteProductSubmitted(
    DeleteProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ProductSuccess) {
      return;
    }

    emit(ProductLoading());

    final result = await usecases.deleteProduct(event.id);

    result.fold(
      (failure) => emit(ProductFailure(message: _messageFor(failure))),
      (_) {
        final updatedProducts =
            currentState.products.where((product) => product.id != event.id).toList();
        emit(ProductSuccess(products: updatedProducts));
      },
    );
  }

  String _messageFor(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'Server error, please try again',
      whatoffline: () => 'No internet connection',
      database: () => 'Something went wrong, please try again',
    );
  }
}
