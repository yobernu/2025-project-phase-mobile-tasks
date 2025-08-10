import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ecommerce_app/core/network/network_info.dart';

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
  // Use cases
  sl.registerLazySingleton(() => GetChats(sl()));
  sl.registerLazySingleton(() => GetChatById(sl()));
  sl.registerLazySingleton(() => GetChatMessages(sl()));
  sl.registerLazySingleton(() => InitiateChat(sl()));
  sl.registerLazySingleton(() => DeleteChat(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      socketService: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Services
  sl.registerLazySingleton(() => SocketService.instance);

  // BLoC
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

  // External dependencies (if not already registered)
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }
  
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }
  
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
      internetConnectionChecker: InternetConnectionChecker.instance,
    ));
  }
}
