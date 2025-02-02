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

    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;

    // Define breakpoints for responsiveness
    final bool isMobile = screenWidth <= 600;
    final bool isTablet = screenWidth > 600 && screenWidth <= 1200;
    // final bool isDesktop = screenWidth > 1200;

    final double titleFontSize = isMobile
        ? 24
        : isTablet
            ? 28
            : 32; // Larger font size for tablet and desktop
    final double inputFontSize = isMobile
        ? 16
        : isTablet
            ? 18
            : 20; // Larger font size for tablet and desktop
    final double buttonFontSize = isMobile
        ? 18
        : isTablet
            ? 20
            : 22; // Larger font size for tablet and desktop

    // Calculate responsive card width
    final double cardWidth = isMobile
        ? screenWidth * 0.9
        : isTablet
            ? screenWidth * 0.7
            : screenWidth * 0.5; // Wider card for tablet and desktop

    // Calculate responsive padding
    final double cardPadding = isMobile
        ? 20
        : isTablet
            ? 30
            : 40; // Larger padding for tablet and desktop

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
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: cardWidth,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  margin: EdgeInsets.all(cardPadding * 0.5),
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Login',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize,
                              color: kBlueColor[700]),
                        ),
                        kHeight16,
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: const OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: inputFontSize),
                          ),
                          style: TextStyle(fontSize: inputFontSize),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        kHeight16,
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: inputFontSize)),
                          style: TextStyle(fontSize: inputFontSize),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                        ),
                        kHeight16,
                        SizedBox(
                          width: double.infinity,
                          height: isMobile ? 50 : 60,
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
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: buttonFontSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        kHeight16,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
