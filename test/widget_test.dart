import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/application/auth/auth_bloc.dart';
import 'package:restaurant_app/application/cart/cart_bloc.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/main.dart';

// Mock classes for Bloc
class MockAuthBloc extends Mock implements AuthBloc {}

class MockCartBloc extends Mock implements CartBloc {}

class MockProductBloc extends Mock implements ProductBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockCartBloc mockCartBloc;
  late MockProductBloc mockProductBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockCartBloc = MockCartBloc();
    mockProductBloc = MockProductBloc();

    // Mocking necessary behaviors
    when(mockAuthBloc.state).thenReturn(AuthState.initial());
    when(mockCartBloc.state).thenReturn(CartState.initial());
    when(mockProductBloc.state).thenReturn(ProductState.initial());
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Wrap MyApp in a test-friendly environment with mocked dependencies
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<CartBloc>.value(value: mockCartBloc),
          BlocProvider<ProductBloc>.value(value: mockProductBloc),
        ],
        child: const MaterialApp(
          home: MyApp(
            isLoggedIn: false,
            userToken: null,
          ),
        ),
      ),
    );

    // Verify that the app builds and the initial UI is correct
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Perform a tap on the '+' button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter has incremented
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
