import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_local_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/message_local_data_source.dart';
import 'package:ecommerce_app/features/messaging/data/datasource/message_remote_datasource.dart';
import 'package:ecommerce_app/features/messaging/data/repository/chat_repository_impl.dart';
import 'package:ecommerce_app/features/messaging/domain/repository/chat_repository.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/create_chat_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/get_chat_by_id_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/get_my_chat_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/message_usecases/mark_as_read_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/message_usecases/resend_pending_messages_usecase.dart';
import 'package:ecommerce_app/features/messaging/domain/usecases/message_usecases/send_messages.usecase.dart';
import 'package:ecommerce_app/features/messaging/presentation/provider/chat_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sl = GetIt.instance;

  // Bloc
  sl.registerFactory(
    () => ChatBloc(
      createChatUseCase: sl(),
      getChatByIdUseCase: sl(),
      getChatsForUserUseCase: sl(),
      getMessageUseCase: sl(),
      sendMessageUseCase: sl(),
      markAsReadUseCase: sl(),
      resendPendingMessagesUseCase: sl(), 
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateChatUseCase(sl()));
  sl.registerLazySingleton(() => GetChatByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetChatsForUserUseCase(sl()));
  sl.registerLazySingleton(() => GetChatsForUserUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
  sl.registerLazySingleton(() => ResendPendingMessagesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remote: sl(),
      local: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(client: sl(), prefs: sl()),
  );

  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(prefs: sl()),
  );

  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(client: sl(), socket: sl(), prefs: sl()),
  );

  sl.registerLazySingleton<MessageLocalDataSource>(
    () => MessageLocalDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetConnectionChecker: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
}