class DashboardStats {
  final int? totalMovies;
  final int? totalActors;
  final int? totalGenres;
  final int? totalUsers;
  final int? totalHalls;
  final int? totalShows;
  final int? totalReservations;
  final int? activeShows;

  DashboardStats({
    this.totalMovies,
    this.totalActors,
    this.totalGenres,
    this.totalUsers,
    this.totalHalls,
    this.totalShows,
    this.totalReservations,
    this.activeShows,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalMovies: json['totalMovies'],
      totalActors: json['totalActors'],
      totalGenres: json['totalGenres'],
      totalUsers: json['totalUsers'],
      totalHalls: json['totalHalls'],
      totalShows: json['totalShows'],
      totalReservations: json['totalReservations'],
      activeShows: json['activeShows'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMovies': totalMovies,
      'totalActors': totalActors,
      'totalGenres': totalGenres,
      'totalUsers': totalUsers,
      'totalHalls': totalHalls,
      'totalShows': totalShows,
      'totalReservations': totalReservations,
      'activeShows': activeShows,
    };
  }
} 