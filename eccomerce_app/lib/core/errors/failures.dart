import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  String get errorMessage => message ?? 'An unknown error occurred';

  @override
  List<Object?> get props => [message];

  @override
  String toString() =>
      message != null ? '$runtimeType: $message' : '$runtimeType';
}

// Common failure types for the ecommerce app
class ServerFailure extends Failure {
  // final String message;

  // const ServerFailure([this.message = 'Server error occurred']);
  const ServerFailure([String? message]) : super(message ?? '');
  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([String? message])
    : super(message ?? 'Network connection failed');

  @override
  List<Object?> get props => [message];
}

class ProductNotFoundFailure extends Failure {
  final int productId;

  const ProductNotFoundFailure(this.productId, [String? message])
    : super(message ?? 'Product $productId not found');

  @override
  List<Object?> get props => [productId, message];
}

class ChatFailure extends Failure {
  const ChatFailure([String? message]) : super(message ?? '');

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([String? message])
    : super(message ?? 'Cache error occurred');

  @override
  List<Object?> get props => [message];
}
