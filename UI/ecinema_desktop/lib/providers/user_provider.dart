import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecinema_desktop/models/user.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';
import 'package:ecinema_desktop/providers/auth_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5190/User/login'),
        headers: { 'Content-Type': 'application/json', },
        body: jsonEncode({ 'username': username, 'password': password, }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        AuthProvider.password = password;
        AuthProvider.setUser(user);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static User? getCurrentUser() {
    if (AuthProvider.userId == null) return null;
    
    return User(
      id: AuthProvider.userId,
      firstName: AuthProvider.firstName ?? '',
      lastName: AuthProvider.lastName ?? '',
      username: AuthProvider.username ?? '',
      email: AuthProvider.email ?? '',
      phoneNumber: AuthProvider.phoneNumber,
      createdAt: AuthProvider.createdAt,
      role: AuthProvider.role,
    );
  }

  static Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    String? phoneNumber,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5190/User/register'),
        headers: { 'Content-Type': 'application/json', },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'username': username,
          'phoneNumber': phoneNumber,
          'password': password,
          'roleId': 1,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
} 