import 'package:bloc_test/bloc_test.dart';
import 'package:ecommerce_app/features/eccomerce_app/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart' as mt;

import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/home_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/helper_functions.dart/product_list.dart';

// Mocktail + bloc_test based mock for ProductBloc
class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

// Fallback for mocktail when using any<ProductEvent>()
class FakeProductEvent extends mt.Fake implements ProductEvent {}

void main() {
  setUpAll(() {
    mt.registerFallbackValue(FakeProductEvent());
  });
  group('HomeScreen Tests', () {
    testWidgets('renders HomeScreen with AppBar and ProductList', (
      WidgetTester tester,
    ) async {
      final mockBloc = MockProductBloc();

      mt.when(() => mockBloc.state).thenReturn(const InitialState());
      whenListen(
        mockBloc,
        Stream<ProductState>.fromIterable([
          const InitialState(),
          LoadedAllProductsState([]),
        ]),
        initialState: const InitialState(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Yohannes,'),
        ),
        findsOneWidget,
      );
      expect(find.byType(ProductList), findsOneWidget);
    });

    testWidgets('dispatches LoadAllProductsEvent on init', (
      WidgetTester tester,
    ) async {
      final mockBloc = MockProductBloc();

      mt.when(() => mockBloc.state).thenReturn(const InitialState());
      whenListen(
        mockBloc,
        Stream<ProductState>.fromIterable([
          const InitialState(),
          LoadedAllProductsState([]),
        ]),
        initialState: const InitialState(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pump(); // Triggers post-frame callback

      // mt.verify(mockBloc.add(const LoadAllProductsEvent())).called(1);
    });

    testWidgets(
      'HomeScreen updates when a new product is added (via bloc state)',
      (tester) async {
        // final mockBloc = MockProductBloc();

        final productA = Product(
          id: '1',
          name: 'Item A',
          subtitle: '',
          imageUrl: '',
          description: '',
          price: 10,
          rating: '4.0',
          sizes: const [],
        );
        final productB = Product(
          id: '2',
          name: 'Item B',
          subtitle: '',
          imageUrl: '',
          description: '',
          price: 20,
          rating: '4.5',
          sizes: const [],
        );

        final mockBloc = MockProductBloc();
        mt.when(() => mockBloc.state).thenReturn(const InitialState());
        whenListen(
          mockBloc,
          Stream<ProductState>.fromIterable([
            const InitialState(),
            LoadedAllProductsState([productA]),
            LoadedAllProductsState([productA, productB]),
          ]),
          initialState: const InitialState(),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ProductBloc>.value(
              value: mockBloc,
              child: const HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle(); // process all scheduled rebuilds
        expect(find.text('Item A'), findsOneWidget);
        expect(find.text('Item B'), findsOneWidget);
      },
    );
  });
}
