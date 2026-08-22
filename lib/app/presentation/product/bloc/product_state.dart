import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/product_entity.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<ProductEntity> products;

  const ProductSuccess({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductFailure extends ProductState {
  final String message;
  final List<ProductEntity>? products;

  const ProductFailure({required this.message, this.products});

  @override
  List<Object?> get props => [message, products];
}
