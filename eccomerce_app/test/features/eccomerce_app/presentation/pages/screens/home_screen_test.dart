import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/home_screen.dart';
// ignore: use_function_type_syntax_for_parameters
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/helper_functions.dart/product_list.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([ProductBloc])
void main() {
  testWidgets('renders HomeScreen with AppBar and ProductList', (
    WidgetTester tester,
  ) async {
    // Arrange: provide a mock bloc with an initial state and no emissions
    final mockBloc = MockProductBloc();
    when(mockBloc.state).thenReturn(const InitialState());
    when(mockBloc.stream).thenAnswer((_) => const Stream<ProductState>.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    // AppBar builds a RichText, not a Text; use a predicate
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
    when(mockBloc.state).thenReturn(const InitialState());
    when(mockBloc.stream).thenAnswer((_) => const Stream<ProductState>.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: const HomeScreen(),
        ),
      ),
    );

    await tester.pump(); // Triggers post-frame callback

    verify(mockBloc.add(const LoadAllProductsEvent())).called(1);
  });
}
