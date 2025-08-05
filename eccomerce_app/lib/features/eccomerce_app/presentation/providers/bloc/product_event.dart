
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';

@immutable
abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class LoadAllProductsEvent extends ProductEvent {
  const LoadAllProductsEvent();
  
  @override
  List<Object?> get props => [];
}

class GetSingleProductEvent extends ProductEvent {
  final String productId;
  
  const GetSingleProductEvent(this.productId);
  
  @override
  List<Object?> get props => [productId];
}

class UpdateProductEvent extends ProductEvent {
  final Product product;
  
  const UpdateProductEvent(this.product);
  
  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String productId;
  
  const DeleteProductEvent(this.productId);
  
  @override
  List<Object?> get props => [productId];
}

class CreateProductEvent extends ProductEvent {
  final Product product;
  
  const CreateProductEvent(this.product);
  
  @override
  List<Object?> get props => [product];
}












// LoadAllProductsEvent (1 point): 
// GetSingleProductEvent (1 point)
// UpdateProductEvent (1 point)
//  DeleteProductEvent (1 point)
// CreateProductEvent (1 point):
