void main() {
  ProductManager pm = ProductManager([]);
  
  pm.addProduct("book", "best-book", 120);
  pm.addProduct("pen", "blue ink pen", 10);

  print("All Products:");
  pm.viewProducts();
  

  print("\nView Single Product (book):");
  pm.viewSingleProduct("book");

  print("\nUpdate Product (book):");
  pm.updateProduct("book", "math", "updated-book", 150);
  pm.viewSingleProduct("math");

  print("\nDelete Product (pen):");
  pm.deleteProduct("pen");
  pm.viewProducts();
} 

class Product {
  String? name, description;
  int? price;

  Product(this.name, this.description, this.price);

  @override
  String toString() {
    return '[$name, $description, $price]';
  }
}

class ProductManager {
  List<Product> products;

  ProductManager(this.products);

  void addProduct(String name, String description, int price) {
    Product p1 = Product(name, description, price);
    products.add(p1);
  }

  void viewProducts() {
    for (var pro in products) {
      print(pro);
    }
  }

  void viewSingleProduct(String name) {
    for (var pro in products) {
      if (pro.name == name) {
        print(pro);
        return;
      }
    }
    print("Product '$name' not found.");
  }

  void updateProduct(String firstName, name, String description, int price) {
    for (var pro in products) {
      if (pro.name == firstName) {
        pro.name = name;
        pro.description = description;
        pro.price = price;
        print("Product '$firstName' updated successfully.");
        return;
      }
    }
    print("Product '$name' not found for update.");
  }

  void deleteProduct(String name) {
    int initialLength = products.length;
    products.removeWhere((pro) => pro.name == name);

    if (products.length < initialLength) {
      print("Product '$name' deleted.");
    } else {
      print("Product '$name' not found.");
    }
  }
}
