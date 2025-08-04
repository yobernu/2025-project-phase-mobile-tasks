import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';


class ProductModel extends Product {
  const ProductModel({
    int? id,
    String? price,
    String? description,
    String? title,
    String? imagePath,
    String? rating,
    List<String>? sizes,
    String? subtitle,
  }) : super(
    id: id ?? 0,
    price: price ?? '',
    description: description ?? '',
    title: title ?? '',
    imagePath: imagePath ?? '',
    rating: rating ?? '4.0',
    sizes: sizes ?? const <String>[],
    subtitle: subtitle ?? '',
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      price: json['price'],
      description: json['description'],
      title: json['title'],
      imagePath: json['imagePath'],
      rating: json['rating'],
      sizes: (json['sizes'] as List<dynamic>).cast<String>(),
      subtitle: json['subtitle'],
    );
  }
}
