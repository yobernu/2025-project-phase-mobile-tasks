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