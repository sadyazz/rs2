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

  static Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('${_baseUrl}User/change-password'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        final errorMessage = jsonDecode(response.body);
        throw Exception(errorMessage);
      }
      return false;
    } catch (e) {
      print('Change password error: $e');
      rethrow;
    }
    }

  static Future<bool> updateUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    String? phoneNumber,
    String? image,
  }) async {
    print('DEBUG: updateUser called with: firstName=$firstName, lastName=$lastName, email=$email, phoneNumber=$phoneNumber');
    print('DEBUG: Base URL: $_baseUrl');
    print('DEBUG: Username: ${AuthProvider.username}');
    print('DEBUG: Password: ${AuthProvider.password?.substring(0, 3)}...');
    
    try {
      final userId = AuthProvider.userId;
      if (userId == null) {
        throw Exception('User ID not found');
      }
      
      final url = Uri.parse('${_baseUrl}User/$userId');
      print('DEBUG: Making PUT request to: $url with userId: $userId');
      
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          'image': image,
        }),
      );

      print('DEBUG: Response status code: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('DEBUG: Success - returning true');
        return true;
      } else if (response.statusCode == 400) {
        final errorMessage = jsonDecode(response.body);
        print('DEBUG: Bad request error: $errorMessage');
        throw Exception(errorMessage);
      }
      print('DEBUG: Unexpected status code - returning false');
      return false;
    } catch (e) {
      print('DEBUG: Exception in updateUser: $e');
      rethrow;
    }
  }

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
} 