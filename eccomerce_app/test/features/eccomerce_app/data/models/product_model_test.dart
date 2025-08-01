import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tProductModal = ProductModel(
    id: 1,
    price: '100',
    description: 'Product Description',
    title: 'Product Title',
    imagePath: 'https://via.placeholder.com/150',
    rating: '4.0',
    sizes: ['S', 'M', 'L'],
    subtitle: 'Product Subtitle',
  );

  test('should be a subclass of Product entity',
   () async{
    expect(tProductModal, isA<Product>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is valid',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixtures('product.json'));
        final result = ProductModel.fromJson(jsonMap);
        expect(result, tProductModal);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = tProductModal.toJson();
        final expectedJsonMap = {
          'id': 1,
          'price': '100',
          'description': 'Product Description',
          'title': 'Product Title',
          'imagePath': 'https://via.placeholder.com/150',
          'rating': '4.0',
          'sizes': ['S', 'M', 'L'],
          'subtitle': 'Product Subtitle',
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}

// arrange,     act, assert