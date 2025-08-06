import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final List<String> sizes;
  final String description;
  

  const Product({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    this.rating = '4.0',
    required this.sizes,
    required this.description,
  });


   Product copyWith({
    int? id,
    String? imagePath,
    String? title,
    String? subtitle,
    String? price,
    String? rating,
    List<String>? sizes,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      sizes: sizes ?? this.sizes,
      description: description ?? this.description,
    );
  }



 
  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      imagePath: json['imagePath'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      price: json['price'] as String,
      rating: json['rating'] as String,
      sizes: (json['sizes'] as List).cast<String>(),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'rating': rating,
      'sizes': sizes,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [
    id,
    imagePath,
    title,
    subtitle,
    price,
    rating,
    sizes,
    description,
  ];
}