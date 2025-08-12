import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/usecases/usecases.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetChats implements UseCase<List<Chat>, NoParams> {
  final ChatRepository repository;

  GetChats(this.repository);

  @override
  Future<Either<Failure, List<Chat>>> call(NoParams params) async {
    return await repository.getChats();
  }
}
