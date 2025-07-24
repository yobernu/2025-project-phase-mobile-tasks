import 'product.dart';


var products = ProductList.products;

void deleteProduct(String id) {
    products.removeWhere((pro) => pro.id == id);
  }









