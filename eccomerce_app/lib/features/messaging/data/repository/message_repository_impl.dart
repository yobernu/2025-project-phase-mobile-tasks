import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/auth/data/models/auth_model.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_local_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/modal/chat_model.dart';
import 'package:ecommerce_app/features/messaging/data/modal/message_model.dart';
import 'package:ecommerce_app/features/messaging/domain/entities/message.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {

  final ChatRemoteDataSource remote;
  final ChatLocalDataSource local;
  final NetworkInfo network;

  
  const MessageRepositoryImpl(this.remote, this.local, this.network);
  @override
  Future<Either<Failure, Message>> sendMessage({required Message message}) async {
    try {
      final model = MessageModel(
      id: message.id,
      sender: UserModel.fromEntity(message.sender),
      chat: ChatModel(
        id: message.chat.id,
        user1: UserModel.fromEntity(message.chat.user1),
        user2: UserModel.fromEntity(message.chat.user2),
      ),
      content: message.content,
      type: message.type,
    );

      // TODO: Send to API or local DB
      // await apiClient.post('/messages', data: model.toJson());

      // Simulate success by returning the entity back
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // Send to API or local DB
  // await apiClient.post('/messages', data: model.toJson());
}
