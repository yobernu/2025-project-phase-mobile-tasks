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
  const NetworkFailure([super.message = 'Network error occurred']);
}

// Server failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
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
  const InvalidProductFailure([super.message = 'Invalid product data']);
}
