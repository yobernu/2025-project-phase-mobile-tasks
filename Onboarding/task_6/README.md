# Product Management Flutter App

## Overview
This Flutter app is a simple product management system that allows users to:
- View a list of products on the **Homepage**
- Add new products via the **Add Product** page
- Tap on a product to view its **Details Page**
  - Select a size
  - Delete the product
  - Update the product (navigates to the **Update Product** page)

## Main Features
- **Homepage:** Displays all products in a grid. Each product card shows an image, title, price, and rating. An **Add Product** button is available to add new products.
- **Add Product Page:** Allows users to input details for a new product and add it to the list.
- **Details Page:** Shows detailed information about the selected product. Users can select a size, delete the product, or update its details.
- **Update Product Page:** Lets users modify the details of an existing product.
- **Search Page:** There is a Search Page accessible from the app, but the search functionality is not yet implemented.

## Screenshots
Screenshots of the main pages (Homepage, Add Product, Details, Update Product) are included in the `images/screenshots` directory for reference.

## How to Run the App
1. **Install Flutter:**
   - Make sure you have [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
2. **Get Dependencies:**
   - Navigate to the project directory:
     ```
     cd Onboarding/task_6
     ```
   - Run:
     ```
     flutter pub get
     ```
3. **Run the App:**
   - To run on an emulator or connected device:
     ```
     flutter run
     ```

## Additional Information
- The app uses the `provider` package for state management.
- Product images can be loaded from assets or from files.
- All main features are accessible from the homepage.
- Navigation throughout the app is handled using **NamedRouter**.
- For any issues or questions, please refer to the code comments or contact me yoseph.berhanu@a2sv.org.
