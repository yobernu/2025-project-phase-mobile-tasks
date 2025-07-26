import 'package:flutter/foundation.dart';  // This imports ChangeNotifier
import 'product.dart';
import 'product-list.dart';

class ProductManager with ChangeNotifier {
  List<Product> _products = [];

  ProductManager() {
    _products = List.from(ProductList.products);
  }

  List<Product> get products => _products;

  void addProduct(Product prod) {
    if (prod.title.isEmpty || prod.price.isEmpty) {
      throw ArgumentError('Product must have title and price');
    }
    
    if (products.any((p) => p.title == prod.title)) {
      throw StateError('Product with this name already exists');
    }
    
    _products.add(prod);
    notifyListeners();  // This tells widgets to rebuild
  }

  void deleteProduct(String id) {
    _products.removeWhere((pro) => pro.id == id);
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  
  List<Product> getAll() {
  return _products;
}

}


