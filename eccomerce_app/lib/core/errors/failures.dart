// core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) 
    : super(message);
}

// Server failures
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
    : super(message);
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
    : super(message);
}

// Specific domain failures
class ProductNotFoundFailure extends Failure {
  final String productId;
  
  const ProductNotFoundFailure(this.productId)
    : super('Product $productId not found');
  
  @override
  List<Object?> get props => [productId, message];
}

class InvalidProductFailure extends Failure {
  const InvalidProductFailure([String message = 'Invalid product data'])
    : super(message);
}