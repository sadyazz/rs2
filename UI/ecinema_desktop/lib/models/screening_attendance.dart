class ScreeningAttendance {
  final int screeningId;
  final String movieTitle;
  final String hallName;
  final DateTime startTime;
  final int totalSeats;
  final int reservedSeats;
  final double occupancyRate;

  ScreeningAttendance({
    required this.screeningId,
    required this.movieTitle,
    required this.hallName,
    required this.startTime,
    required this.totalSeats,
    required this.reservedSeats,
    required this.occupancyRate,
  });

  factory ScreeningAttendance.fromJson(Map<String, dynamic> json) {
    return ScreeningAttendance(
      screeningId: json['screeningId'],
      movieTitle: json['movieTitle'],
      hallName: json['hallName'],
      startTime: DateTime.parse(json['startTime']),
      totalSeats: json['totalSeats'],
      reservedSeats: json['reservedSeats'],
      occupancyRate: json['occupancyRate'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screeningId': screeningId,
      'movieTitle': movieTitle,
      'hallName': hallName,
      'startTime': startTime.toIso8601String(),
      'totalSeats': totalSeats,
      'reservedSeats': reservedSeats,
      'occupancyRate': occupancyRate,
    };
  }
}
