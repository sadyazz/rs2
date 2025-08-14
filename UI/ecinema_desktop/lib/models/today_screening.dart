class TodayScreening {
  final int id;
  final String movieTitle;
  final String? movieImage;
  final String hallName;
  final DateTime startTime;
  final DateTime endTime;
  final int reservationCount;
  final int totalSeats;
  final bool isActive;

  TodayScreening({
    required this.id,
    required this.movieTitle,
    this.movieImage,
    required this.hallName,
    required this.startTime,
    required this.endTime,
    required this.reservationCount,
    required this.totalSeats,
    required this.isActive,
  });

  factory TodayScreening.fromJson(Map<String, dynamic> json) {
    return TodayScreening(
      id: json['id'],
      movieTitle: json['movieTitle'],
      movieImage: json['movieImage'],
      hallName: json['hallName'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      reservationCount: json['reservationCount'],
      totalSeats: json['totalSeats'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieTitle': movieTitle,
      'movieImage': movieImage,
      'hallName': hallName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'reservationCount': reservationCount,
      'totalSeats': totalSeats,
      'isActive': isActive,
    };
  }

  double get occupancyRate => totalSeats > 0 ? reservationCount / totalSeats : 0.0;
  String get formattedStartTime => '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  String get formattedEndTime => '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
}
