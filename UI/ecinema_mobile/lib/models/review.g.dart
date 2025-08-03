// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  id: (json['id'] as num?)?.toInt(),
  userName: json['userName'] as String,
  rating: (json['rating'] as num).toDouble(),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  isActive: json['isActive'] as bool,
  isDeleted: json['isDeleted'] as bool,
  isSpoiler: json['isSpoiler'] as bool,
  isEdited: json['isEdited'] as bool?,
  movieId: (json['movieId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'rating': instance.rating,
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'isActive': instance.isActive,
  'isDeleted': instance.isDeleted,
  'isSpoiler': instance.isSpoiler,
  'isEdited': instance.isEdited,
  'movieId': instance.movieId,
};
