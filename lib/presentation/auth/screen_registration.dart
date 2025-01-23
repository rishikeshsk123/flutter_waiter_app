import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenRegistrationWidget extends StatefulWidget {
  const ScreenRegistrationWidget({super.key});

  @override
  State<ScreenRegistrationWidget> createState() =>
      _ScreenRegistrationWidgetState();
}

class _ScreenRegistrationWidgetState extends State<ScreenRegistrationWidget> {
  final TextEditingController _pinController = TextEditingController();

  Future<void> _registerPin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', _pinController.text);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pin registered successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'Enter PIN',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            kHeight16,
            ElevatedButton(
              onPressed: _registerPin,
              child: const Text('Register PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
