// data/models/product_model.dart
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    super.subtitle,
    super.rating = null,
    super.sizes = null,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? 'No Name',
      description: json['description']?.toString() ?? 'No Description',
      price: (json['price'] as num?)?.toString() ?? '0.0',
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
