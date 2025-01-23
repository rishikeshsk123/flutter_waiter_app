import 'package:restaurant_app/domain/model/user/user.dart';

abstract class AuthRepository {
  // Future<void> signup({required String email, required String password});
  Future<User> login(String email,  String password);
  Future<void> logout();
  // Future<bool> isAuthenticated();
  Future<User?> checkAuthStatus();
}