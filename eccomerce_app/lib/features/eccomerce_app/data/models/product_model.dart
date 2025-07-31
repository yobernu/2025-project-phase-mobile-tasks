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
}
