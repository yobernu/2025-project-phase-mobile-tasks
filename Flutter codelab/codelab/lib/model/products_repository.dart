import 'product.dart';

class ProductsRepository {
  static List<Product> loadProducts(Category category) {
    const allProducts = <Product>[
      Product(
        name: 'Vase',
        price: 49.99,
        category: Category.home,
        assetName: 'images/vase.jpg',
      ),
      Product(
        name: 'T-shirt',
        price: 29.99,
        category: Category.clothing,
        assetName: 'images/tshirt.jpg',
      ),
      Product(
        name: 'Watch',
        price: 199.99,
        category: Category.accessories,
        assetName: 'images/watch.jpg',
      ),
      Product(
        name: 'Sofa',
        price: 599.99,
        category: Category.home,
        assetName: 'images/sofa.jpg',
      ),
      Product(
        name: 'Watch',
        price: 199.99,
        category: Category.accessories,
        assetName: 'images/watch.jpg',
      ),
      Product(
        name: 'Sofa',
        price: 599.99,
        category: Category.home,
        assetName: 'images/sofa.jpg',
      ),
    ];

    if (category == Category.all) {
      return allProducts;
    } else {
      return allProducts
        .where((p) => p.category == category)
        .toList();
    }
  }
}
