# Ecommerce Flutter App

# Task-23
## Chating feature
A modern Flutter ecommerce application built with Clean Architecture principles, featuring product management

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with a clear separation of concerns across different layers:

### Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  (UI Components, Pages, Widgets, State Management)        │
├─────────────────────────────────────────────────────────────┤
│                     Domain Layer                           │
│  (Entities, Use Cases, Repository Interfaces)             │
├─────────────────────────────────────────────────────────────┤
│                      Data Layer                            │
│  (Models, Repository Implementations, Data Sources)       │
├─────────────────────────────────────────────────────────────┤
│                      Core Layer                            │
│  (Shared Utilities, Errors, Constants)                    │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Principles

- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Interface Segregation**: Clients depend only on interfaces they use
- **Dependency Rule**: Dependencies point inward, domain layer has no dependencies

## 📊 Data Flow

### 1. Data Flow Diagram

```
User Action → UI → Use Case → Repository → Data Source
     ↑                                    ↓
     └────────── Response ←───────────────┘
```

### 2. Detailed Flow

1. **User Interaction**: User performs an action (e.g., view product details)
2. **UI Layer**: Widgets handle user input and trigger appropriate use cases
3. **Use Case Layer**: Business logic is executed through use cases
4. **Repository Layer**: Data access is abstracted through repository interfaces
5. **Data Layer**: Actual data operations (API calls, local storage, etc.)
6. **Response Flow**: Data flows back through the same layers to the UI

### 3. Error Handling Flow

```
Exception → Failure Object → Either<Failure, Success> → UI Error Display
```

## 📁 Project Structure

```
lib/
├── core/                           # Shared utilities and core functionality
│   ├── constants/
│   │   └── api_constants.dart     # API endpoints and constants
│   ├── errors/
│   │   └── failures.dart          # Error handling and failure types
│   └── usecases.dart/
│       └── usecases.dart          # Base use case interfaces
├── features/
│   └── eccomerce_app/             # Main ecommerce feature
│       ├── data/                  # Data layer implementation
│       │   ├── models/
│       │   │   └── product_model.dart      # Data models
│       │   └── repositories/
│       │       └── product_repository_impl.dart  # Repository implementations
│       └── domain/                # Domain layer (business logic)
│           ├── entities/
│           │   └── product.dart   # Business entities
│           ├── repositories/
│           │   └── product_repository.dart  # Repository interfaces
│           └── usecases/          # Business use cases
│               ├── delete_product.dart
│               ├── get_product_by_id.dart
│               ├── insert_product.dart
│               └── update_product.dart
├── main.dart                      # App entry point
├── home_page.dart                 # Main home screen
├── details_page.dart              # Product details page
├── add_product.dart               # Add product form
├── update_page.dart               # Update product form
├── search_page.dart               # Product search
└── product_manager.dart           # State management
```

## 🧪 Testing Structure

```
test/
├── core/
│   └── errors/
│       └── failures.dart          # Error handling tests
├── features/
│   └── eccomerce_app/
│       ├── data/
│       │   └── models/
│       │       └── product_model_test.dart  # Model tests
│       └── domain/
│           ├── entities/
│           │   └── product.dart
│           ├── repositories/
│           │   └── product_repository.dart
│           └── usecases/          # Use case tests
│               ├── delete_product_test.dart
│               ├── get_product_by_id_test.dart
│               ├── insert_product_test.dart
│               └── update_product_test.dart
└── fixtures/                      # Test data
    ├── fixture_reader.dart
    └── product.json
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eccomerce_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file ex. product_model_Test
flutter test test/features/eccomerce_app/data/models/product_model_test.dart

# Run tests with coverage
flutter test --coverage
```

## 🛠️ Key Technologies & Dependencies

### Core Dependencies
- **Flutter**: UI framework
- **Dart**: Programming language
- **Provider**: State management
- **Equatable**: Value equality
- **Dartz**: Functional programming utilities

### Development Dependencies
- **flutter_test**: Testing framework
- **mockito**: Mocking library (for testing)

## 📱 Features

### Current Features
- ✅ Entities and Usecases
- ✅ Product - Model
- ✅ Clean Architecture implementation
- ✅ Comprehensive testing

## 🧪 Testing Strategy

### Test Types
1. **Unit Tests**: Test individual components in isolation
3. **Integration Tests**: Test complete user flows

### Testing Principles
- **AAA Pattern**: Arrange, Act, Assert
- **Test Isolation**: Each test is independent
- **Mocking**: External dependencies are mocked
- **Coverage**: Aim for high test coverage

### Example Test Structure
```dart
test('should return a valid model when the JSON is valid', () async {
  // Arrange
  final Map<String, dynamic> jsonMap = json.decode(fixtures('product.json'));
  
  // Act
  final result = ProductModel.fromJson(jsonMap);
  
  // Assert
  expect(result, tProductModal);
});
```

## 🔧 Development Guidelines

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Architecture Guidelines
- Keep domain layer independent
- Use dependency injection
- Implement proper error handling
- Follow SOLID principles

### Git Workflow
- Use feature branches
- Write descriptive commit messages
- Review code before merging
- Keep commits atomic

## 📈 Performance Considerations

- Use `const` constructors where possible


## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## 📄 License
- A2SV Project phase mobile track


**Built with ❤️ using Flutter and Clean Architecture**
