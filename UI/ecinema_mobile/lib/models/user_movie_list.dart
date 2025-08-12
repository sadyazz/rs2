import 'movie.dart';

class UserMovieList {
  final int? id;
  final int? userId;
  final int? movieId;
  final String? listType; // 'watched', 'watchlist', 'favorites'
  final DateTime? createdAt;
  final bool? isDeleted;
  final Movie? movie;

  const UserMovieList({
    this.id,
    this.userId,
    this.movieId,
    this.listType,
    this.createdAt,
    this.isDeleted,
    this.movie,
  });

  factory UserMovieList.fromJson(Map<String, dynamic> json) {
    return UserMovieList(
      id: json['id'],
      userId: json['userId'],
      movieId: json['movieId'],
      listType: json['listType'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      isDeleted: json['isDeleted'] ?? false,
      movie: json['movie'] != null ? Movie.fromJson(json['movie']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'movieId': movieId,
      'listType': listType,
      'createdAt': createdAt?.toIso8601String(),
      'isDeleted': isDeleted,
      'movie': movie?.toJson(),
    };
  }
} 