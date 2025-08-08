import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:ecommerce_app/features/auth/data/datasource/auth_local_data_sources.dart';
import 'package:ecommerce_app/features/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:ecommerce_app/features/auth/data/repositories/repository.dart';
import 'package:ecommerce_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/signout_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/provider/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final ls = GetIt.instance;

  ls.registerFactory(
    () => UserBloc(
      userRepository: ls())
  );


// Usecases
  ls.registerSingleton(() => SignUpUseCase(ls()));
  ls.registerSingleton(() => LoginUseCase(ls()));
  ls.registerSingleton(() => SignOutUseCase(ls()));



  //repositories
  ls.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    local: ls(),
    remote: ls(),
    networkInfo: ls(),
    ));

  ls.registerLazySingleton<LocalAuthDataSource>(() => LocalAuthDataSourceImpl(prefs: ls()));
  ls.registerLazySingleton<RemoteAuthDataSource>(() => RemoteAuthDataSourceImpl(client: ls()));

  // Core
  ls.registerLazySingleton(() => InputConverter());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  ls.registerLazySingleton(() => sharedPreferences);
  ls.registerLazySingleton(() => http.Client());
  ls.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnectionChecker: ls()));
  ls.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  


}

