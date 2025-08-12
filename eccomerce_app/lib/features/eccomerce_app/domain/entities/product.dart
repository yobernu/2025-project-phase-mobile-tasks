// domain/entities/product.dart
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final String? subtitle; // Make nullable if not always present
  final String? rating; // Make nullable
  final List<String>? sizes; // Make nullable

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.subtitle,
    this.rating = '4.0',
    this.sizes = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price':
          double.tryParse(price) ?? 0.0, // Convert string to double for API
      'imageUrl': imageUrl,
      if (subtitle != null) 'subtitle': subtitle,
      if (rating != null) 'rating': rating,
      if (sizes != null) 'sizes': sizes,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    subtitle,
    rating,
    sizes,
  ];
}
