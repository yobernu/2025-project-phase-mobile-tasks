// dependency_injection.dart
import 'package:ecommerce_app/core/services/auth_services.dart';
import 'package:ecommerce_app/features/auth/data/datasource/auth_local_data_sources.dart';
import 'package:ecommerce_app/features/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:ecommerce_app/features/auth/data/repositories/repository.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/check_out_status_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:ecommerce_app/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:ecommerce_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/delete_chat.dart';
import 'package:ecommerce_app/features/chat/data/services/socket_service.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_chat_by_id.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_chat_messages.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_chats.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/initiate_chat.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/send_message.dart';
import 'package:ecommerce_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/datasources/product_local_data_sources.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/datasources/product_remote_data_sources.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_all_products.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_product_by_id.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/insert_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Core
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';

// Auth Feature

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetConnectionChecker: sl()),
  );
  // Core
  sl.registerLazySingleton<AuthService>(() => AuthService(prefs: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Socket Service
  sl.registerLazySingleton<SocketService>(() => SocketService.instance);

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => getApplicationDocumentsDirectory());

  //! Features - Auth
  // Data sources
  sl.registerLazySingleton<RemoteAuthDataSource>(
    () => RemoteAuthDataSourceImpl(authService: sl(), client: sl()),
  );
  sl.registerLazySingleton<LocalAuthDataSource>(
    () => LocalAuthDataSourceImpl(prefs: sl()),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remote: sl(), local: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => UserBloc(
      signUpUseCase: sl(),
      loginUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      getCurrentUserUseCase: sl(),
      connectionChecker: sl(),
    ),
  );

  //! Features - Ecommerce
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSources>(
    () => ProductRemoteDataSourcesImpl(authService: sl(), client: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSources>(
    () => ProductLocalDataSourcesImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => InsertProduct(sl()));

  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getAllProductsUsecase: sl(),
      getSingleProductUsecase: sl(),
      updateProductUsecase: sl(),
      deleteProductUsecase: sl(),
      createProductUsecase: sl(),
      inputConverter: sl(),
    ),
  );

  //! Features - Chat
  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(client: sl(), authService: sl()),
  );

  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      socketService: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetChats(sl()));
  sl.registerLazySingleton(() => GetChatById(sl()));
  sl.registerLazySingleton(() => GetChatMessages(sl()));
  sl.registerLazySingleton(() => InitiateChat(sl()));
  sl.registerLazySingleton(() => DeleteChat(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Bloc
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
