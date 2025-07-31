import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

// Base UseCase interface
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Base Params class
abstract class Params extends Equatable {
  const Params();
}

// NoParams for use cases that don't need parameters
class NoParams extends Params {
  const NoParams();
  
  @override
  List<Object?> get props => [];
}