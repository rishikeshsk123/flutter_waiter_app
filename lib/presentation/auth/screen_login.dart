import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/application/auth/auth_bloc.dart';
import 'package:restaurant_app/core/colors/colors.dart';
import 'package:restaurant_app/core/constant.dart';
import 'package:restaurant_app/presentation/main_page/screen_main_page.dart';

class ScreenLoginWidget extends StatelessWidget {
  const ScreenLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    final passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: kGreyColor[200],
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signing In...')),
              );
            },
            authenticated: (user) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (ctx) => ScreenMainPage()),
              );
            },
            unauthenticated: () {},
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          );
        },
        builder: (context, state) {
          // if (state is LoadingState) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          return Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: kBlueColor[700]),
                    ),
                    kHeight16,
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Email is required";
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    kHeight16,
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Password is required";
                        return null;
                      },
                    ),
                    kHeight16,
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (email.isNotEmpty && password.isNotEmpty) {
                            context.read<AuthBloc>().add(AuthEvent.login(
                                email: email, password: password));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all fields.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlueColor[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    kHeight16,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
