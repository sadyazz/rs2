class Revenue {
  final DateTime date;
  final String? movieTitle;
  final String? hallName;
  final double totalRevenue;
  final int reservationCount;
  final double averageTicketPrice;

  Revenue({
    required this.date,
    this.movieTitle,
    this.hallName,
    required this.totalRevenue,
    required this.reservationCount,
    required this.averageTicketPrice,
  });

  factory Revenue.fromJson(Map<String, dynamic> json) {
    return Revenue(
      date: DateTime.parse(json['date']),
      movieTitle: json['movieTitle'],
      hallName: json['hallName'],
      totalRevenue: json['totalRevenue'].toDouble(),
      reservationCount: json['reservationCount'],
      averageTicketPrice: json['averageTicketPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'movieTitle': movieTitle,
      'hallName': hallName,
      'totalRevenue': totalRevenue,
      'reservationCount': reservationCount,
      'averageTicketPrice': averageTicketPrice,
    };
  }
}
