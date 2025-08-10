import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return const Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure() : super('Invalid input: Must be a positive integer');
  
  @override
  List<Object?> get props => [message]; // Include message in props for equality comparison
}