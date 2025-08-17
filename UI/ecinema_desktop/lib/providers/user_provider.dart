import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecinema_desktop/models/user.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';
import 'package:ecinema_desktop/providers/auth_provider.dart';

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        
        AuthProvider.username = username;
        AuthProvider.password = password;
        AuthProvider.setUser(user);
        
        return true;
      }

        return response.statusCode == 200;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  @override
  User fromJson(data) {
    final user = User.fromJson(data);
    return user;
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
      image: AuthProvider.image,
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

  static Future<bool> updateUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    String? phoneNumber,
  }) async {
    try {
      final userId = AuthProvider.userId;
      if (userId == null) {
        throw Exception('User ID not found');
      }
      
      final url = Uri.parse('${_baseUrl}User/$userId');
      
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
      print('DEBUG: Exception in updateUser: $e');
      rethrow;
    }
  }

  static Future<User?> getCurrentUserProfile() async {
    try {
      final userId = AuthProvider.userId;
      if (userId == null) {
        throw Exception('User ID not found');
      }
      
      final url = Uri.parse('${_baseUrl}User/$userId');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      print('DEBUG: Exception in getCurrentUserProfile: $e');
      return null;
    }
  }

  Future<void> updateUserRole(int userId, Map<String, dynamic> request) async {
    try {
      final headers = createHeaders();
      
      final response = await http.put(
        Uri.parse('http://localhost:5190/User/$userId/role'),
        headers: headers,
        body: jsonEncode(request),
      );
      
      if (response.statusCode == 200) {
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update user role');
      }
    } catch (e) {
      print('DEBUG: Error in updateUserRole: $e');
      throw Exception('Failed to update user role: $e');
    }
  }
} 