class TopCustomer {
  final int userId;
  final String userName;
  final String email;
  final int reservationCount;
  final double totalSpent;

  TopCustomer({
    required this.userId,
    required this.userName,
    required this.email,
    required this.reservationCount,
    required this.totalSpent,
  });

  factory TopCustomer.fromJson(Map<String, dynamic> json) {
    return TopCustomer(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      reservationCount: json['reservationCount'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'reservationCount': reservationCount,
      'totalSpent': totalSpent,
    };
  }
} 
