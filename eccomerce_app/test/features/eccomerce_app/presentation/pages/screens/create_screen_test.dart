import 'dart:io';

import 'package:bloc_test/bloc_test.dart' as bt;
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/create_screen.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/pages/screens/helpers/image_picker.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_event.dart';
import 'package:ecommerce_app/features/eccomerce_app/presentation/providers/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;

class MockImagePickerService extends mt.Mock implements ImagePickerService {}

class MockProductBloc extends bt.MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

class MockProductState extends mt.Mock implements ProductState {}

// Fallback for mocktail to allow using `any<ProductEvent>()`
class FakeProductEvent extends mt.Fake implements ProductEvent {}

void main() {
  late MockImagePickerService mockImagePickerService;
  late MockProductBloc mockProductBloc;

  setUpAll(() {
    mt.registerFallbackValue(FakeProductEvent());
  });

  setUp(() {
    mockImagePickerService = MockImagePickerService();
    mockProductBloc = MockProductBloc();
  });

  group('CreateScreen Widget Tests', () {
    testWidgets('renders all form fields including addProductsButton', (
      tester,
    ) async {
      // 1. Setup Mocks
      mt.when(() => mockProductBloc.state).thenReturn(const InitialState());
      bt.whenListen(
        mockProductBloc,
        const Stream<ProductState>.empty(),
        initialState: const InitialState(),
      );

      // Stub image picker to avoid side effects
      mt
          .when(() => mockImagePickerService.pickAndSaveImage())
          .thenAnswer((_) async => null);

      // 2. Build Widget with large viewport
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1000, 2000)),
            child: BlocProvider<ProductBloc>.value(
              value: mockProductBloc,
              child: CreateScreen(imagePickerService: mockImagePickerService),
            ),
          ),
        ),
      );

      // 3. Wait for full rendering
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 4. Verify basic fields
      expect(find.text('Name'), findsOneWidget);
      expect(find.byKey(const Key('productPriceField')), findsOneWidget);
      expect(find.text('Sizes (comma separated)'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);

      // 5. Find button through multiple strategies
      final buttonFinder = find.byKey(const Key('addProductsButton'));
      final buttonTextFinder = find.text('ADD PRODUCT');

      if (buttonFinder.evaluate().isEmpty) {
        print('Button not found by key. Searching alternatives...');

        // Scroll to make sure button is visible
        await tester.scrollUntilVisible(
          buttonTextFinder,
          500.0,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        // Verify button exists by text
        expect(buttonTextFinder, findsOneWidget);

        // Get the actual ElevatedButton widget
        final elevatedButtonFinder = find.ancestor(
          of: buttonTextFinder,
          matching: find.byType(ElevatedButton),
        );

        expect(elevatedButtonFinder, findsOneWidget);

        // Verify it has the correct key
        final button = tester.widget<ElevatedButton>(elevatedButtonFinder);
        expect(button.key, const Key('addProductsButton'));
      } else {
        expect(buttonFinder, findsOneWidget);
      }

      // 6. Test form submission
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

      // 7. Handle image picker interaction safely
      // For valid submission, ensure image picker returns a file
      mt
          .when(() => mockImagePickerService.pickAndSaveImage())
          .thenAnswer((_) async => File('test_path'));
      final imageFinder = find.byKey(const Key('productImageField'));
      await tester.ensureVisible(imageFinder);
      await tester.pumpAndSettle();
      await tester.tap(imageFinder, warnIfMissed: false);
      await tester.pumpAndSettle();

      // 8. Submit form (robust finder and visibility)
      Finder submitButton = find.byKey(const Key('addProductsButton'));
      if (submitButton.evaluate().isEmpty) {
        final buttonTextFinder = find.text('ADD PRODUCT');
        // Ensure text is visible and derive the ElevatedButton ancestor
        if (buttonTextFinder.evaluate().isEmpty) {
          await tester.scrollUntilVisible(
            buttonTextFinder,
            400.0,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.pumpAndSettle();
        }
        submitButton = find.ancestor(
          of: buttonTextFinder,
          matching: find.byType(ElevatedButton),
        );
      }

      if (submitButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(submitButton);
        await tester.pumpAndSettle();
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
      } else {
        fail('Submit button not found by key or text.');
      }
      expect(submitButton, findsOneWidget);

      // //confirm dialog
      // expect(find.byType(AlertDialog), findsOneWidget);
      // await tester.tap(find.byKey(const Key('cancelButton')));
      // await tester.pumpAndSettle();
      // expect(find.byType(AlertDialog), findsNothing);

      //adding product
      // 1) Tap dialog add button
      await tester.tap(find.byKey(const Key('addButton')));
      await tester.pumpAndSettle();

      // 2) Verify the bloc received the create event with expected args
      mt
          .verify(
            () => mockProductBloc.add(
              mt.any(
                // Prefer matching your concrete event class, e.g. CreateProductEvent
                that: isA<CreateProductEvent>(),
              ),
            ),
          )
          .called(1);
    });
  });
}
