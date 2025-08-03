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

   group('cacheProduct', () {
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
    final Product tProduct = tProductModel;
    
    test('should call the [SharedPreferences.setString] function with the correct values', () async {
      // Arrange
      final expectedJsonString = json.encode(tProduct.toJson());
      when(mockSharedPreferences.setString('CACHED_PRODUCT', expectedJsonString)).thenAnswer((_) async => true);
      
      // Act
      await dataSource.cacheProduct(tProduct);
      
      // Assert
      verify(mockSharedPreferences.setString('CACHED_PRODUCT', expectedJsonString));
    });
  });


   group('clearCache', () {
    test('should remove all cached values when called', () async {
      // Arrange
      when(mockSharedPreferences.remove('CACHED_PRODUCTS')).thenAnswer((_) async => true);
      when(mockSharedPreferences.remove('CACHED_PRODUCT')).thenAnswer((_) async => true);
      
      // Act
      await dataSource.clearCache();
      
      // Assert
      verify(mockSharedPreferences.remove('CACHED_PRODUCTS')).called(1);
      verify(mockSharedPreferences.remove('CACHED_PRODUCT')).called(1);
    });
  });



  group('deleteProduct', () {
    test('should remove the cached product when called', () async {
      // Arrange
      when(mockSharedPreferences.remove('CACHED_PRODUCT_4')).thenAnswer((_) async => true);
      
      // Act
      await dataSource.deleteProduct(4);
      
      // Assert
      verify(mockSharedPreferences.remove('CACHED_PRODUCT_4')).called(1);
    });
  });


  
  group('getProductById', () {
    test('should return the cached product when called', () async {
      // Arrange
      final tProduct = ProductModel.fromJson(json.decode(fixtures('product_cached.json')));
      when(mockSharedPreferences.getString('CACHED_PRODUCT_4')).thenReturn(json.encode(tProduct.toJson()));
      // Act
      final result = await dataSource.getProductById(4);
      
      // Assert
      verify(mockSharedPreferences.getString('CACHED_PRODUCT_4')).called(1);
      expect(result, equals(tProduct));
    });
  });



group('updateProduct', () {
    test('should update the cached product by id when called (overwrite)', () async {
      // Arrange
      final tUpdatedProduct = ProductModel(
        description: 'test description',
        id: 4,
        imagePath: 'test image path',
        price: '100',
        rating: '4.5',
        subtitle: 'test subtitle',
        title: 'test title',
        sizes: ['S', 'M', 'L'],
      );

      final updatedJsonString = json.encode(tUpdatedProduct.toJson());
      when(mockSharedPreferences.setString('CACHED_PRODUCT_4', updatedJsonString)).thenAnswer((_) async => true);

     //act
      await dataSource.updateProduct(tUpdatedProduct);
      
      // Assert
      verify(mockSharedPreferences.setString('CACHED_PRODUCT_4', updatedJsonString)).called(1);
      // expect(result, equals(tUpdatedProduct));
    });
  });


}
