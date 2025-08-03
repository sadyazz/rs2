import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  int? id;
  String userName;
  double rating;
  String? comment;
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive;
  bool isDeleted;
  bool isSpoiler;
  bool? isEdited;
  int? movieId;

  Review({
    this.id,
    required this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
    required this.isDeleted,
    required this.isSpoiler,
    this.isEdited,
    this.movieId,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
} 