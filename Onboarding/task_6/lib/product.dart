class Product {
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final String rating;
  final List<String> sizes;
  final String description;

  Product({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.sizes,
    required this.description,
  });

  static final Product product1 = Product(
    imagePath: 'images/shoe.jpg',
    title: 'Derby Leather Shoes',
    subtitle: 'Men\'s Shoes',
    price: '\$120',
    rating: '4.0',
    sizes: ['39', '40', '41', '42', '43', '44', '45'],
    description: "A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.",
  );
}

  // final Product product1 = Product(
  //   imagePath: 'images/shoe.jpg',
  //   title: 'Derby Leather Shoes',
  //   subtitle: 'Men\'s Shoes',
  //   price: '\$120',
  //   rating: '4.0',
  // );