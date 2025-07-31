class Product {
  final int id;
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final List<String> sizes;
  final String description;
  

  Product({
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

}

class ProductList {
  static List<Product> products = <Product>[
    Product(
      id: 1,
      imagePath: 'images/shoe.jpg',
      title: 'Derby Leather Shoes',
      subtitle: 'Men\'s Shoes',
      price: '\$120',
      sizes: <String>['39', '40', '41', '42', '43', '44', '45'],
      description:
          'A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.',
    ),

     Product(
      id: 2,
      imagePath: 'images/Nike.png',
      title: 'AirForce Shoes',
      subtitle: 'Men\'s Shoes',
      price: '\$80',
      rating: '4.4',
      sizes: <String>['39', '40', '41', '42', '43', '44', '45'],
      description:
          'An AirForce is  a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.',
    ),

    Product(
      id: 3,
      imagePath: 'images/shoe.jpg',
      title: 'Derby Leather Shoes',
      subtitle: 'Men\'s Shoes',
      price: '\$120',
      sizes: <String>['39', '40', '41', '42', '43', '44', '45'],
      description:
          'A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.',
    ),
  ];
}





// Product(
//       id: "2",
//       imagePath: 'images/Nike.png',
//       title: 'AirForce Shoes',
//       subtitle: 'Men\'s Shoes',
//       price: '\$80',
//       rating: '4.4',
//       sizes: ['39', '40', '41', '42', '43', '44', '45'],
//       description:
//           "An AirForce is  a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.",
//     ),