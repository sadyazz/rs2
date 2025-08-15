import 'package:json_annotation/json_annotation.dart';
import 'package:ecinema_desktop/models/role.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? phoneNumber;
  final bool isDeleted;
  final Role? role;
  final DateTime? createdAt;
  final String? image;

  const User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.isDeleted = false,
    this.role,
    this.createdAt,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phoneNumber,
    bool? isDeleted,
    Role? role,
    DateTime? createdAt,
    String? image,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDeleted: isDeleted ?? this.isDeleted,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
    );
  }

  String get fullName => '$firstName $lastName';
} 