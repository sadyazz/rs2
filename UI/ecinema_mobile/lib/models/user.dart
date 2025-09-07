import 'role.dart';

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? username;
  final String? phoneNumber;
  final String? image;
  final Role? role;
  final DateTime? createdAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.phoneNumber,
    this.image,
    this.role,
    this.createdAt,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      image: json['image'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'username': username,
    'phoneNumber': phoneNumber,
    'image': image,
    'role': role?.toJson(),
    'createdAt': createdAt?.toIso8601String(),
  };
}