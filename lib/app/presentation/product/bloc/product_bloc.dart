import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/usecases/product_usecases.dart';

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

    try {
      final products = await usecases.getProducts();

      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductFailure(message: e.toString()));
    }
  }

  Future<void> _onAddProductSubmitted(
    AddProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final name = event.name.trim();

      if (name.isEmpty) {
        emit(const ProductFailure(message: 'Product name cannot be empty'));
        return;
      }

      await usecases.createProduct(
        name: name,
        price: event.price,
        description: event.description.trim(),
      );

      final products = await usecases.getProducts();

      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdateProductSubmitted(
    UpdateProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final name = event.name.trim();

      if (name.isEmpty) {
        emit(const ProductFailure(message: 'Product name cannot be empty'));
        return;
      }

      await usecases.updateProduct(
        id: event.id,
        name: name,
        price: event.price,
        description: event.description.trim(),
      );

      final products = await usecases.getProducts();

      emit(ProductSuccess(products: products));
    } catch (e) {
      emit(ProductFailure(message: e.toString()));
    }
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

    try {
      await usecases.deleteProduct(event.id);

      final updatedProducts = currentState.products
          .where((product) => product.id != event.id)
          .toList();

      emit(ProductSuccess(products: updatedProducts));
    } catch (e) {
      emit(ProductFailure(message: e.toString()));
    }
  }
}
