import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/application/auth/auth_bloc.dart';
import 'package:restaurant_app/core/colors/colors.dart';
import 'package:restaurant_app/core/constant.dart';
import 'package:restaurant_app/presentation/auth/screen_login.dart';
import 'package:restaurant_app/presentation/splashScreen/splash.dart';

class ScreenProfile extends StatelessWidget {
  const ScreenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    final userName = authState.maybeWhen(
      authenticated: (user) => user.name,
      orElse: () => "Guest",
    );

    final userEmail = authState.maybeWhen(
      authenticated: (user) => user.email,
      orElse: () => "Not available",
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: kBlueColor[700]),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
              unauthenticated: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) =>  ScreenLoginWidget()),
                  (route) => false,
                );
              },
              orElse: () {});
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: $userName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              kHeight16,
              Text(
                'Email: $userEmail',
                style: TextStyle(fontSize: 16),
              ),
              kHeight16,
              // const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEvent.logout());
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
