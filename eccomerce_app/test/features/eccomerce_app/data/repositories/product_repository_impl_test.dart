import 'package:mockito/mockito.dart';
import 'package:eccomerce_app/features/eccomerce_app/data/datasources/product_local_data_sources.dart';
import 'package:eccomerce_app/features/eccomerce_app/data/datasources/product_remote_data_sources.dart';
import 'package:eccomerce_app/core/platform/network_info.dart';
import 'package:eccomerce_app/features/eccomerce_app/data/repositories/product_repository_impl.dart';


// Mock remote data source
class MockRemoteDataSource extends Mock 
  implements ProductRemoteDataSources {}

// Mock local data source
class MockLocalDataSource extends Mock 
  implements ProductLocalDataSources {}

// Mock network info
class MockNetworkInfo extends Mock 
  implements NetworkInfo {}


void main() {
  ProductRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;



  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
}



