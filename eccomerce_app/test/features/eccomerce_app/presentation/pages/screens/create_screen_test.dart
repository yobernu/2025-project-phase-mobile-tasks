import 'dart:io';

import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/create_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/helpers/image_picker.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
// Import your actual files

class MockImagePickerService extends Mock implements ImagePickerService {}

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

void main() {
  late MockImagePickerService mockImagePickerService;
  late MockProductBloc mockProductBloc;

  setUp(() {
    mockImagePickerService = MockImagePickerService();
    mockProductBloc = MockProductBloc();
  });

  group('CreateScreen Widget Tests', () {
    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: CreateScreen(imagePickerService: mockImagePickerService),
          ),
        ),
      );

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Price'), findsOneWidget);
      expect(find.text('Sizes (comma separated)'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.byKey(const Key('addProductButton')), findsOneWidget);
    });

    testWidgets('shows error when submitting empty form', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: CreateScreen(imagePickerService: mockImagePickerService),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('addProductButton')));
      await tester.pump();

      expect(find.text('This field is required'), findsNWidgets(4));
    });

    testWidgets('shows image picker dialog when image area is tapped', (
      tester,
    ) async {
      when(
        mockImagePickerService.pickAndSaveImage(),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: CreateScreen(imagePickerService: mockImagePickerService),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('productImageField')));
      await tester.pump();

      verify(mockImagePickerService.pickAndSaveImage()).called(1);
    });

    testWidgets('shows confirmation dialog when form is valid', (tester) async {
      when(
        mockImagePickerService.pickAndSaveImage(),
      ).thenAnswer((_) async => File('test_path'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: CreateScreen(imagePickerService: mockImagePickerService),
          ),
        ),
      );

      // Fill out form
      await tester.enterText(
        find.byKey(const Key('productNameField')),
        'Test Product',
      );
      await tester.enterText(
        find.byKey(const Key('productPriceField')),
        '19.99',
      );
      await tester.enterText(
        find.byKey(const Key('productSizeField')),
        'M,L,XL',
      );
      await tester.enterText(
        find.byKey(const Key('productDescriptionField')),
        'Test description',
      );

      // Tap image field to set image
      await tester.tap(find.byKey(const Key('productImageField')));
      await tester.pump();

      // Tap submit button
      await tester.tap(find.byKey(const Key('addProductButton')));
      await tester.pump();

      expect(find.text('Confirm new Product'), findsOneWidget);
    });
  });
}
