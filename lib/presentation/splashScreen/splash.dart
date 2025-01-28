import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/application/auth/auth_bloc.dart';
import 'package:restaurant_app/presentation/auth/screen_login.dart';
import 'package:restaurant_app/presentation/main_page/screen_main_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            state.maybeWhen(
              authenticated: (_) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  ScreenMainPage()),
              ),
              unauthenticated: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  ScreenLoginWidget()),
              ),
              orElse: () {},
            );
          },
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
