import 'package:ecinema_desktop/models/user.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  static const String _baseUrl = "http://localhost:5190/";

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

      return response.statusCode == 200;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
} 