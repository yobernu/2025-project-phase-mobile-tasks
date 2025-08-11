import 'package:get_it/get_it.dart';

// Domain
import 'domain/repositories/chat_repository.dart';
import 'domain/usecases/get_chats.dart';
import 'domain/usecases/get_chat_by_id.dart';
import 'domain/usecases/get_chat_messages.dart';
import 'domain/usecases/initiate_chat.dart';
import 'domain/usecases/delete_chat.dart';
import 'domain/usecases/send_message.dart';

// Data
import 'data/repositories/chat_repository_impl.dart';
import 'data/datasources/chat_remote_data_source.dart';
import 'data/datasources/chat_local_data_source.dart';
import 'data/services/socket_service.dart';

// Presentation
import 'presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> initChatFeature() async {
  // Use cases - check if already registered
  if (!sl.isRegistered<GetChats>()) {
    sl.registerLazySingleton(() => GetChats(sl()));
  }
  if (!sl.isRegistered<GetChatById>()) {
    sl.registerLazySingleton(() => GetChatById(sl()));
  }
  if (!sl.isRegistered<GetChatMessages>()) {
    sl.registerLazySingleton(() => GetChatMessages(sl()));
  }
  if (!sl.isRegistered<InitiateChat>()) {
    sl.registerLazySingleton(() => InitiateChat(sl()));
  }
  if (!sl.isRegistered<DeleteChat>()) {
    sl.registerLazySingleton(() => DeleteChat(sl()));
  }
  if (!sl.isRegistered<SendMessage>()) {
    sl.registerLazySingleton(() => SendMessage(sl()));
  }

  // Repository
  if (!sl.isRegistered<ChatRepository>()) {
    sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
        socketService: sl(),
      ),
    );
  }

  // Data sources
  if (!sl.isRegistered<ChatRemoteDataSource>()) {
    sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(client: sl()),
    );
  }

  if (!sl.isRegistered<ChatLocalDataSource>()) {
    sl.registerLazySingleton<ChatLocalDataSource>(
      () => ChatLocalDataSourceImpl(sharedPreferences: sl()),
    );
  }

  // Services
  if (!sl.isRegistered<SocketService>()) {
    sl.registerLazySingleton(() => SocketService.instance);
  }

  // BLoC - using registerFactory is fine for multiple instances
  if (!sl.isRegistered<ChatBloc>()) {
    sl.registerFactory(
      () => ChatBloc(
        getChats: sl(),
        getChatById: sl(),
        getChatMessages: sl(),
        initiateChat: sl(),
        deleteChat: sl(),
        sendMessage: sl(),
        chatRepository: sl(),
      ),
    );
  }

  // External dependencies are now registered in auth injection container
  // No need to register them again here since they're shared dependencies
}
