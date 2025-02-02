import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_app/application/auth/auth_bloc.dart';
import 'package:restaurant_app/application/cart/cart_bloc.dart';
import 'package:restaurant_app/application/product/product_bloc.dart';
import 'package:restaurant_app/domain/core/di/injectable.dart';
import 'package:restaurant_app/presentation/splashScreen/splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();

  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');

   final isTablet = await checkIfTablet();

  if (!isTablet) {
    // Lock screen for mobile & desktop (Android only)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  runApp(MyApp(
    isLoggedIn: token != null,
    userToken: token,
  ));
}

// Function to detect if the device is a tablet
Future<bool> checkIfTablet() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  // Check if device is a tablet (based on smallest screen width)
  return androidInfo.systemFeatures.contains('android.hardware.screen.landscape');
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userToken;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    this.userToken,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(const AuthEvent.started()),
        ),
        BlocProvider(
          create: (_) => CartBloc(userToken: userToken ?? ''),
        ),
        BlocProvider(
          create: (_) => getIt<ProductBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const SplashScreen(),
      ),
    );
  }
}
