import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';
import '../models/user.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");
  static const String _baseUrl = "http://10.0.2.2:5190/";

  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}User/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        
        AuthProvider.username = username;
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
        Uri.parse('${_baseUrl}User/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'username': username,
          'phoneNumber': phoneNumber,
          'password': password,
          'roleId': 2,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}User'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return data.first;
        }
      }
      return null;
    } catch (e) {
      print('Get user profile error: $e');
      return null;
    }
  }

    @override
  User fromJson(data) {
    return User.fromJson(data);
  }
} 