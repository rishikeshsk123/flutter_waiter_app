import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_app/application/auth/auth_bloc.dart';
import 'package:restaurant_app/application/cart/cart_bloc.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/domain/core/di/injectable.dart';
import 'package:restaurant_app/infrastructure/product/product_repository_impl.dart';
import 'package:restaurant_app/presentation/splashScreen/splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();

  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');

  runApp(
    MyApp(
      isLoggedIn: token != null,
      userToken: token,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? userToken;
  final bool isLoggedIn;
  const MyApp({
    super.key,
    this.userToken,
    required this.isLoggedIn,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(const AuthEvent.started()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(
            userToken: userToken ?? '',
          ),
        ),
        BlocProvider(create: (ctx) => getIt<ProductBloc>())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
