// data/models/product_model.dart
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    String? subtitle,
    String? rating,
    List<String>? sizes,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
          subtitle: subtitle,
          rating: rating,
          sizes: sizes,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? 'No Name',
      description: json['description']?.toString() ?? 'No Description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      rating: json['rating']?.toString(),
      sizes: json['sizes'] != null 
          ? (json['sizes'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      if (subtitle != null) 'subtitle': subtitle,
      if (rating != null) 'rating': rating,
      if (sizes != null) 'sizes': sizes,
    };
  }
}