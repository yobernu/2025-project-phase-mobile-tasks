// Ecommerce app using dart


// void main() {
//   ProductManager pm = ProductManager([]);
  
//   pm.addProduct("book", "best-book", 120);
//   pm.addProduct("pen", "blue ink pen", 10);

//   print("All Products:");
//   pm.viewProducts();
  

//   print("\nView Single Product (book):");
//   pm.viewSingleProduct("book");

//   print("\nUpdate Product (book):");
//   pm.updateProduct("book", "math", "updated-book", 150);
//   pm.viewSingleProduct("math");

//   print("\nDelete Product (pen):");
//   pm.deleteProduct("pen");
//   pm.viewProducts();
// } 

// class Product {
//   String? name, description;
//   int? price;

//   Product(this.name, this.description, this.price);

//   @override
//   String toString() {
//     return '[$name, $description, $price]';
//   }
// }

// class ProductManager {
//   List<Product> products;

//   ProductManager(this.products);

//   void addProduct(String name, String description, int price) {
//     Product p1 = Product(name, description, price);
//     products.add(p1);
//   }

//   void viewProducts() {
//     for (var pro in products) {
//       print(pro);
//     }
//   }

//   void viewSingleProduct(String name) {
//     for (var pro in products) {
//       if (pro.name == name) {
//         print(pro);
//         return;
//       }
//     }
//     print("Product '$name' not found.");
//   }

//   void updateProduct(String firstName, name, String description, int price) {
//     for (var pro in products) {
//       if (pro.name == firstName) {
//         pro.name = name;
//         pro.description = description;
//         pro.price = price;
//         print("Product '$firstName' updated successfully.");
//         return;
//       }
//     }
//     print("Product '$name' not found for update.");
//   }

//   void deleteProduct(String name) {
//     int initialLength = products.length;
//     products.removeWhere((pro) => pro.name == name);

//     if (products.length < initialLength) {
//       print("Product '$name' deleted.");
//     } else {
//       print("Product '$name' not found.");
//     }
//   }
// }



/// Enum that enumerates the different planets in our solar system
/// and some of their properties.
/// 











enum PlanetType {terrestrial, gas, ice}

enum Planet {
  mercury(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  venus(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  // ···
  uranus(planetType: PlanetType.ice, moons: 27, hasRings: true),
  neptune(planetType: PlanetType.ice, moons: 14, hasRings: true);

  /// A constant generating constructor
  const Planet({
    required this.planetType,
    required this.moons,
    required this.hasRings,
  });

  /// All instance variables are final
  final PlanetType planetType;
  final int moons;
  final bool hasRings;

  /// Enhanced enums support getters and other methods
  bool get isGiant =>
      planetType == PlanetType.gas || planetType == PlanetType.ice;
}


void main() {
  
final yourPlanet = Planet.uranus;

if (!yourPlanet.isGiant) {
  print('Your planet is not a "giant planet".');
} 
else {
  print("your planet $yourPlanet is giant planet");
}
}