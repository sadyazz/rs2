import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  int? id;
  int? userId;
  int? movieId;
  int? rating;
  String? comment;
  bool? isDeleted;
  bool? isSpoiler;
  DateTime? createdAt;
  DateTime? modifiedAt;
  bool? isEdited;
  String? userName;

  Review({
    this.id,
    this.userId,
    this.movieId,
    this.rating,
    this.comment,
    this.isDeleted,
    this.isSpoiler,
    this.createdAt,
    this.modifiedAt,
    this.isEdited,
    this.userName,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
} 