import 'dart:convert';

import 'package:ecommerce_app/core/errors/exceptions.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/datasources/product_local_data_sources.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'product_local_data_source_test.mocks.dart';

void main() {
  late ProductLocalDataSourcesImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourcesImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getAllProducts', () {
    final tProductModel = ProductModel.fromJson(json.decode(fixtures('product_cached.json')));
    
    test('should return all Products from sharedpreferences when there is cached one', 
    () async {
      // Arrange
      final cachedJson = json.encode([json.decode(fixtures('product_cached.json'))]);
      when(mockSharedPreferences.getString('CACHED_PRODUCTS')).thenReturn(cachedJson);
      // Act
      final result = await dataSource.getAllProducts();
      // Assert
      verify(mockSharedPreferences.getString('CACHED_PRODUCTS'));
      expect(result, equals([tProductModel]));
    });

    test('should throw a CacheException when there is not a cached value', 
    () async {
      // Arrange
      when(mockSharedPreferences.getString('CACHED_PRODUCTS')).thenReturn(null);
      // Act & Assert
      expect(() => dataSource.getAllProducts(), throwsA(isA<CacheException>()));
      verify(mockSharedPreferences.getString('CACHED_PRODUCTS'));
    });
  });

  group('cacheProducts', () {
    final tProductModel = ProductModel(
      description: 'test description',
      id: 1,
      imagePath: 'test image path',
      price: '100',
      rating: '4.5',
      subtitle: 'test subtitle',
      title: 'test title',
      sizes: ['S', 'M', 'L'],
    );
    final List<ProductModel> tProducts = [tProductModel];
    
    test('should call the [SharedPreferences.setString] function with the correct values', () async {
      // Arrange
      final expectedJsonString = json.encode(tProducts.map((product) => product.toJson()).toList());
      when(mockSharedPreferences.setString('CACHED_PRODUCTS', expectedJsonString)).thenAnswer((_) async => true);
      
      // Act
      await dataSource.cacheProducts(tProducts);
      
      // Assert
      verify(mockSharedPreferences.setString('CACHED_PRODUCTS', expectedJsonString));
    });
  });
}
