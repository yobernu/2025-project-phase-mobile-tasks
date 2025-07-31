import 'package:ecommerce_app/features/eccomerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

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
}