import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:restaurant_app/domain/auth/auth_repository.dart';
import 'package:restaurant_app/domain/model/user/user.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<User> login(String email, String password) async {
    // Simulating an API response
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@example.com' && password == 'password123') {
      final user = User(
        id: '1',
        name: 'Test User',
        email: email,
        token: 'mock_token',
      );

      // Store user data as a JSON string
      await _secureStorage.write(key: 'auth_token', value: user.token);
      await _secureStorage.write(
          key: 'user_data', value: jsonEncode(user.toJson()));
      return user;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_data');
  }

  @override
  Future<User?> checkAuthStatus() async {
   
      final token = await _secureStorage.read(key: 'auth_token');
      final userData = await _secureStorage.read(key: 'user_data');

      if (token != null && userData != null) {
        try {
        // Parse the JSON string into a Map<String, dynamic>
        final Map<String, dynamic> userMap = jsonDecode(userData);
        return User.fromJson(userMap);
      } catch (e) {
        throw Exception('Error in checkAuthStatus: ${e.toString()}');
      }
      }
    
    return null;
  }
}
