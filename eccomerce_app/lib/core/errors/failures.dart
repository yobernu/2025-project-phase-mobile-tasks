import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
}

// Common failure types for the ecommerce app
class ServerFailure extends Failure {
  final String message;
  
  const ServerFailure([this.message = 'Server error occurred']);
  
  @override
  List<Object?> get props => [message];
}






class NetworkFailure extends Failure {
  final String message;
  
  const NetworkFailure([this.message = 'Network error occurred']);
  
  @override
  List<Object?> get props => [message];
}




class CacheFailure extends Failure {
  final String message;
  const CacheFailure([this.message = 'Cache error occurred']);
  @override
  List<Object?> get props => [message];
}




class ProductNotFoundFailure extends Failure {
  final int productId;
  
  const ProductNotFoundFailure(this.productId);
  
  @override
  List<Object?> get props => [productId];
}

