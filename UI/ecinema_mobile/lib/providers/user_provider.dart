import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';
import '../models/user.dart';
import '../models/reservation_response.dart';
import '../config/api_config.dart';
import '../utils/user_session.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");
  static String get _baseUrl => ApiConfig.baseUrl;
  // static String get _baseUrl => "http://localhost:5190/";

  static User? getCurrentUser() {
    if (AuthProvider.userId == null) return null;
    
    final user = User(
      id: AuthProvider.userId,
      firstName: AuthProvider.firstName,
      lastName: AuthProvider.lastName,
      username: AuthProvider.username,
      email: AuthProvider.email,
      phoneNumber: AuthProvider.phoneNumber,
      createdAt: AuthProvider.createdAt,
      role: AuthProvider.role,
      image: AuthProvider.image,
    );
    
    return user;
  }

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
        print('🔍 Login response data: $data');
        
        final user = User.fromJson(data);
        print('🔍 Parsed user: ${user.toJson()}');
        print('🔍 User ID: ${user.id}');
        
        AuthProvider.username = username;
        AuthProvider.password = password;
        AuthProvider.setUser(user);
        
        UserSession.currentUser = user;
        
        print('🔍 AuthProvider.userId after setUser: ${AuthProvider.userId}');
        
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

      print('🔍 Register response status: ${response.statusCode}');
      print('🔍 Register response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        try {
          final errorMessage = response.body.isNotEmpty ? jsonDecode(response.body) : 'Registration failed';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception(response.body.isNotEmpty ? response.body : 'Registration failed');
        }
      }
    } catch (e) {
      print('Register error: $e');
      rethrow;
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
          'image': image,
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
  

  static Future<ReservationResponse> verifyReservation(int reservationId) async {
    try {
      final authHeader = 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}';
      print('🔍 Auth header: $authHeader');
      print('🔍 Username: ${AuthProvider.username}');
      
      final response = await http.post(
        Uri.parse('${_baseUrl}Reservation/verify/$reservationId'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
      );

      print('🔍 Response status code: ${response.statusCode}');
      print('🔍 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🔍 Parsed data: $data');
        return ReservationResponse.fromJson(data);
      } else {
        print('🔍 Error response body: ${response.body}');
        throw Exception(response.body.isNotEmpty ? response.body : 'Server returned ${response.statusCode} with no body');
      }
    } catch (e) {
      print('Verify reservation error: $e');
      rethrow;
    }
  }

  static Future<ReservationResponse> cancelReservation(int reservationId) async {
    try {
      final authHeader = 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}';
      
      final response = await http.post(
        Uri.parse('${_baseUrl}Reservation/cancel/$reservationId'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ReservationResponse.fromJson(data);
      } else {
        throw Exception(response.body.isNotEmpty ? response.body : 'Server returned ${response.statusCode} with no body');
      }
    } catch (e) {
      print('Cancel reservation error: $e');
      rethrow;
    }
  }

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }
} 