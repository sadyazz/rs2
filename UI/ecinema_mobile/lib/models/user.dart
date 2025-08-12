class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final bool? isDeleted;
  final DateTime? createdAt;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.username,
    this.email,
    this.phoneNumber,
    this.isDeleted,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'isDeleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
} 