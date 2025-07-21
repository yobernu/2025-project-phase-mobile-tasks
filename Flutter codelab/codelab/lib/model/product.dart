enum Category { all, accessories, clothing, home }

class Product {
  const Product({
    required this.name,
    required this.price,
    required this.category,
    required this.assetName,
    this.assetPackage,
  });

  final String name;
  final double price;
  final Category category;
  final String assetName;
  final String? assetPackage;
}
