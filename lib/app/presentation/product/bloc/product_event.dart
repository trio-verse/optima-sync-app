import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class AddProductSubmitted extends ProductEvent {
  final String name;
  final double price;
  final String description;

  const AddProductSubmitted({
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  List<Object?> get props => [name, price, description];
}

class UpdateProductSubmitted extends ProductEvent {
  final String id;
  final String name;
  final double price;
  final String description;

  const UpdateProductSubmitted({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, price, description];
}

class DeleteProductSubmitted extends ProductEvent {
  final String id;

  const DeleteProductSubmitted({required this.id});

  @override
  List<Object?> get props => [id];
}
