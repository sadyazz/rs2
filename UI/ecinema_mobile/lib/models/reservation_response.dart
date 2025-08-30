class ReservationResponse {
  final int id;
  final DateTime reservationTime;
  final double totalPrice;
  final double originalPrice;
  final double discountPercentage;
  final String status;
  final bool isDeleted;
  final int userId;
  final String userName;
  final int screeningId;
  final String movieTitle;
  final DateTime screeningStartTime;
  final List<int> seatIds;
  final List<String> seatNames;
  final int numberOfTickets;
  final int? promotionId;
  final String? promotionName;
  final int? paymentId;
  final String? paymentStatus;
  final String reservationState;
  final String? movieImage;
  final String hallName;
  final String? paymentType;

  ReservationResponse({
    required this.id,
    required this.reservationTime,
    required this.totalPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.status,
    required this.isDeleted,
    required this.userId,
    required this.userName,
    required this.screeningId,
    required this.movieTitle,
    required this.screeningStartTime,
    required this.seatIds,
    required this.seatNames,
    required this.numberOfTickets,
    this.promotionId,
    this.promotionName,
    this.paymentId,
    this.paymentStatus,
    required this.reservationState,
    this.movieImage,
    required this.hallName,
    this.paymentType,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    return ReservationResponse(
      id: json['id'],
      reservationTime: DateTime.parse(json['reservationTime']),
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,
      originalPrice: json['originalPrice']?.toDouble() ?? 0.0,
      discountPercentage: json['discountPercentage']?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      userId: json['userId'],
      userName: json['userName'] ?? '',
      screeningId: json['screeningId'],
      movieTitle: json['movieTitle'] ?? '',
      screeningStartTime: DateTime.parse(json['screeningStartTime']),
      seatIds: List<int>.from(json['seatIds'] ?? []),
      seatNames: List<String>.from(json['seatNames'] ?? []),
      numberOfTickets: json['numberOfTickets'],
      promotionId: json['promotionId'],
      promotionName: json['promotionName'],
      paymentId: json['paymentId'],
      paymentStatus: json['paymentStatus'],
      reservationState: json['reservationState'] ?? '',
      movieImage: json['movieImage'],
      hallName: json['hallName'] ?? '',
      paymentType: json['paymentType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservationTime': reservationTime.toIso8601String(),
      'totalPrice': totalPrice,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'status': status,
      'isDeleted': isDeleted,
      'userId': userId,
      'userName': userName,
      'screeningId': screeningId,
      'movieTitle': movieTitle,
      'screeningStartTime': screeningStartTime.toIso8601String(),
      'seatIds': seatIds,
      'seatNames': seatNames,
      'numberOfTickets': numberOfTickets,
      'promotionId': promotionId,
      'promotionName': promotionName,
      'paymentId': paymentId,
      'paymentStatus': paymentStatus,
      'reservationState': reservationState,
      'movieImage': movieImage,
      'hallName': hallName,
      'paymentType': paymentType,
    };
  }
}