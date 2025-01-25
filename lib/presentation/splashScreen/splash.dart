import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/application/auth/auth_bloc.dart';
import 'package:restaurant_app/presentation/auth/screen_login.dart';
import 'package:restaurant_app/presentation/dine_in/screen_dine_in.dart';
import 'package:restaurant_app/presentation/main_page/screen_main_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            state.when(
      initial: () {
        // Do nothing, waiting for the state to change.
      },
      loading: () {
        // Optionally show a loading indicator.
      },
      authenticated: (user) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => ScreenMainPage()),
        );
      },
      unauthenticated: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => const ScreenLoginWidget()),
        );
      },
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
          },
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
