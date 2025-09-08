class MovieRevenue {
  final int movieId;
  final String movieTitle;
  final String movieImage;
  final int reservationCount;
  final double totalRevenue;

  MovieRevenue({
    required this.movieId,
    required this.movieTitle,
    required this.movieImage,
    required this.reservationCount,
    required this.totalRevenue,
  });

  factory MovieRevenue.fromJson(Map<String, dynamic> json) {
    return MovieRevenue(
      movieId: json['movieId'] ?? 0,
      movieTitle: json['movieTitle'] ?? '',
      movieImage: json['movieImage'] ?? '',
      reservationCount: json['reservationCount'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieId': movieId,
      'movieTitle': movieTitle,
      'movieImage': movieImage,
      'reservationCount': reservationCount,
      'totalRevenue': totalRevenue,
    };
  }
} 
