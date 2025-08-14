import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/helpers/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/home_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/helper_functions.dart/product_list.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([ProductBloc, ImagePickerService])
void main() {
  group('HomeScreen Tests', () {
    testWidgets('renders HomeScreen with AppBar and ProductList', (
      WidgetTester tester,
    ) async {
      final mockBloc = MockProductBloc();

      when(mockBloc.state).thenReturn(const InitialState());
      when(
        mockBloc.stream,
      ).thenAnswer((_) => const Stream<ProductState>.empty());

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

      when(mockBloc.state).thenReturn(const InitialState());
      when(
        mockBloc.stream,
      ).thenAnswer((_) => const Stream<ProductState>.empty());

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
  });
}
