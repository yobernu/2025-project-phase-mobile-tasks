import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:ecommerce_app/features/auth/data/datasource/auth_local_data_sources.dart';
import 'package:ecommerce_app/features/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:ecommerce_app/features/auth/data/repositories/repository.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/check_out_status_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/refreash_token_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/signout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sl = GetIt.instance;

  // Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetConnectionChecker: sl()),
  );

  // External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  // sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  // Data sources
  sl.registerLazySingleton<RemoteAuthDataSource>(
    () => RemoteAuthDataSourceImpl(client: sl()),
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
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => UserBloc(
      signUpUseCase: sl(),
      loginUseCase: sl(),
      signOutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      getCurrentUserUseCase: sl(),
      refreshTokenUseCase: sl(),
      connectionChecker: sl(),
    ),
  );
}
