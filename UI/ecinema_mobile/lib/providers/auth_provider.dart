import '../models/user.dart';

class AuthProvider {
  static String? username;
  static String? password;
  static int? userId;
  static String? firstName;
  static String? lastName;
  static String? fullName;
  static String? email;
  static String? phoneNumber;
  static DateTime? createdAt;
  


  static void setUser(User user) {
    userId = user.id;
    username = user.username;
    firstName = user.firstName;
    lastName = user.lastName;
    fullName = user.fullName;
    email = user.email;
    phoneNumber = user.phoneNumber;
    createdAt = user.createdAt;
    
  }

  static void logout() {
    username = null;
    password = null;
    userId = null;
    firstName = null;
    lastName = null;
    fullName = null;
    email = null;
    phoneNumber = null;
    createdAt = null;
  }


} 