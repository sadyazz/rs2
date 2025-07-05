import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  @JsonKey(name: 'id')
  final int? id;
  
  @JsonKey(name: 'rating')
  final int rating;
  
  @JsonKey(name: 'comment')
  final String? comment;
  
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'modifiedAt')
  final DateTime? modifiedAt;
  
  @JsonKey(name: 'isActive')
  final bool isActive;
  
  @JsonKey(name: 'isDeleted')
  final bool isDeleted;
  
  @JsonKey(name: 'userId')
  final int userId;
  
  @JsonKey(name: 'userName')
  final String userName;
  
  @JsonKey(name: 'userEmail')
  final String userEmail;
  
  @JsonKey(name: 'movieId')
  final int movieId;
  
  @JsonKey(name: 'movieTitle')
  final String movieTitle;

  Review({
    this.id,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.modifiedAt,
    required this.isActive,
    required this.isDeleted,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.movieId,
    required this.movieTitle,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  Review copyWith({
    int? id,
    int? rating,
    String? comment,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? isActive,
    bool? isDeleted,
    int? userId,
    String? userName,
    String? userEmail,
    int? movieId,
    String? movieTitle,
  }) {
    return Review(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      movieId: movieId ?? this.movieId,
      movieTitle: movieTitle ?? this.movieTitle,
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, rating: $rating, comment: $comment, createdAt: $createdAt, isActive: $isActive, userName: $userName, movieTitle: $movieTitle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 