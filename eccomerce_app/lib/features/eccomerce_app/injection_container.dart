import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_all_products.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/insert_product.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/usecases/get_product_by_id.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/datasources/product_remote_data_sources.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<void> init() async {
  final ls = GetIt.instance;

  // Bloc
  ls.registerFactory(
    () => ProductBloc(
      getAllProductsUsecase: ls(),
      getSingleProductUsecase: ls(),
      updateProductUsecase: ls(),
      deleteProductUsecase: ls(),
      createProductUsecase: ls(),
      inputConverter: ls(),
    ),
  );

  // Use cases
  ls.registerLazySingleton(() => GetAllProducts(ls()));
  ls.registerLazySingleton(() => GetProductById(ls()));
  ls.registerLazySingleton(() => UpdateProduct(ls()));
  ls.registerLazySingleton(() => DeleteProduct(ls()));
  ls.registerLazySingleton(() => InsertProduct(ls()));
  ls.registerLazySingleton(() => InputConverter());

  // Repositories
  ls.registerLazySingleton(() => ProductRepositoryImpl(
    remoteDataSource: ls(),
    localDataSource: ls(),
    networkInfo: ls(),
  ));

  // Data sources
  ls.registerLazySingleton(() => ProductRemoteDataSourcesImpl(client: ls()));

  // Core
  ls.registerLazySingleton(() => InputConverter());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  ls.registerLazySingleton(() => sharedPreferences);
  ls.registerLazySingleton(() => http.Client());
  ls.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnectionChecker: ls()));
  ls.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  
  // Image picker for screenshot functionality
  ls.registerLazySingleton(() => ImagePicker());
  
  // Path provider for file storage
  ls.registerLazySingleton(() => getApplicationDocumentsDirectory());
}


