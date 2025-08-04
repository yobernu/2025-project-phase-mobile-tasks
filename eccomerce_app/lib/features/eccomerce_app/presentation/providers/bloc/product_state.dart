import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';

@immutable
abstract class ProductState extends Equatable {
  const ProductState();
}

class InitialState extends ProductState {
  const InitialState();
  
  @override
  List<Object?> get props => [];
}

class LoadingState extends ProductState {
  const LoadingState();
  
  @override
  List<Object?> get props => [];
}

class LoadedAllProductsState extends ProductState {
  final List<Product> products;
  
  const LoadedAllProductsState(this.products);
  
  @override
  List<Object?> get props => [products];
}

class LoadedSingleProductState extends ProductState {
  final Product product;
  
  const LoadedSingleProductState(this.product);
  
  @override
  List<Object?> get props => [product];
}

class ErrorState extends ProductState {
  final String message;
  
  const ErrorState(this.message);
  
  @override
  List<Object?> get props => [message];
}
