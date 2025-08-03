import 'package:flutter/foundation.dart';  // This imports ChangeNotifier
import 'product.dart';

class ProductManager with ChangeNotifier {
  List<Product> _products = <Product>[];

  ProductManager() {
    _products = List<Product>.from(ProductList.products);
  }

  List<Product> get products => _products;

  void addProduct(Product prod) {
    if (prod.title.isEmpty || prod.price.isEmpty) {
      throw ArgumentError('Product must have title and price');
    }
    
    if (products.any((Product p) => p.title == prod.title)) {
      throw StateError('Product with this name already exists');
    }
    
    _products.add(prod);
    notifyListeners();  // This tells widgets to rebuild
  }

  void deleteProduct(String id) {
    _products.removeWhere((Product pro) => pro.id.toString() == id);
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    final int index = _products.indexWhere((Product p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  
  List<Product> getAll() {
  return _products;
}

}


