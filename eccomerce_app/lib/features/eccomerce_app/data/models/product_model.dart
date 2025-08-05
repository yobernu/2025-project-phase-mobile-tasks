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
    // Handle Fake Store API structure
    final rating = json['rating'];
    final ratingValue = rating is Map ? rating['rate']?.toString() ?? '4.0' : rating?.toString() ?? '4.0';
    
    return ProductModel(
      id: json['id'],
      price: json['price']?.toString() ?? '',
      description: json['description'] ?? '',
      title: json['title'] ?? '',
      imagePath: json['image'] ?? json['imagePath'] ?? '', // Handle both 'image' and 'imagePath'
      rating: ratingValue,
      sizes: json['sizes'] != null ? (json['sizes'] as List<dynamic>).cast<String>() : const <String>[],
      subtitle: json['subtitle'] ?? json['category'] ?? '', // Use category as subtitle if available
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'description': description,
      'title': title,
      'imagePath': imagePath,
      'rating': rating,
      'sizes': sizes,
      'subtitle': subtitle,
    };
  }
}
