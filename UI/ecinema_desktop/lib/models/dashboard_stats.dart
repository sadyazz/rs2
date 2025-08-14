class DashboardStats {
  final int? totalMovies;
  final int? totalActors;
  final int? totalGenres;
  final int? totalUsers;
  final int? totalHalls;
  final int? totalShows;
  final int? totalReservations;
  final int? activeShows;
  final Map<String, int>? userCountByRole;

  DashboardStats({
    this.totalMovies,
    this.totalActors,
    this.totalGenres,
    this.totalUsers,
    this.totalHalls,
    this.totalShows,
    this.totalReservations,
    this.activeShows,
    this.userCountByRole,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    Map<String, int>? userCountByRole;
    if (json['userCountByRole'] != null) {
      userCountByRole = Map<String, int>.from(json['userCountByRole']);
    }
    
    return DashboardStats(
      totalMovies: json['totalMovies'],
      totalActors: json['totalActors'],
      totalGenres: json['totalGenres'],
      totalUsers: json['totalUsers'],
      totalHalls: json['totalHalls'],
      totalShows: json['totalShows'],
      totalReservations: json['totalReservations'],
      activeShows: json['activeShows'],
      userCountByRole: userCountByRole,
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
      'userCountByRole': userCountByRole,
    };
  }
} 