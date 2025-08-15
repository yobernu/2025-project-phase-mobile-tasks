import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/details_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/home_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

class FakeProductEvent extends mt.Fake implements ProductEvent {}

void main() {
  setUpAll(() {
    mt.registerFallbackValue(FakeProductEvent());
  });

  testWidgets('details screen should render product details', (tester) async {
    final product = Product(
      id: '1',
      name: 'Test Product',
      subtitle: 'Test Subtitle',
      imageUrl: 'https://via.placeholder.com/150',
      description: 'Test Description',
      price: 10.99,
      rating: '4.5',
      sizes: ['S', 'M', 'L'],
    );

    final mockBloc = MockProductBloc();
    mt.when(() => mockBloc.state).thenReturn(const InitialState());
    whenListen(
      mockBloc,
      Stream<ProductState>.fromIterable([
        const InitialState(),
        LoadedAllProductsState([product]),
      ]),
      initialState: const InitialState(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: DetailsScreen(product: product),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('Test Subtitle'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('\$10.99'), findsOneWidget);
    expect(find.text('(4.5)'), findsOneWidget);
    expect(find.text('S'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);
    expect(find.text('L'), findsOneWidget);
  });

  testWidgets('tapping back pops to HomeScreen', (tester) async {
    final product = Product(
      id: '1',
      name: 'Test Product',
      subtitle: 'Test Subtitle',
      imageUrl: 'https://via.placeholder.com/150',
      description: 'Test Description',
      price: 10.99,
      rating: '4.5',
      sizes: ['S', 'M', 'L'],
    );

    final mockBloc = MockProductBloc();
    mt.when(() => mockBloc.state).thenReturn(const InitialState());
    whenListen(
      mockBloc,
      const Stream<ProductState>.empty(),
      initialState: const InitialState(),
    );

    // Start from HomeScreen
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to DetailsScreen
    Navigator.of(tester.element(find.byType(HomeScreen))).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: DetailsScreen(product: product),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap back
    final backButton = find.byKey(const Key('back_button'));
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Ensure we're back on HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(DetailsScreen), findsNothing);
  });
}
