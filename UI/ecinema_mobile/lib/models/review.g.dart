// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  movieId: (json['movieId'] as num?)?.toInt(),
  rating: (json['rating'] as num?)?.toInt(),
  comment: json['comment'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  isSpoiler: json['isSpoiler'] as bool?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  modifiedAt:
      json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
  isEdited: json['isEdited'] as bool?,
  userName: json['userName'] as String?,
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'movieId': instance.movieId,
  'rating': instance.rating,
  'comment': instance.comment,
  'isDeleted': instance.isDeleted,
  'isSpoiler': instance.isSpoiler,
  'createdAt': instance.createdAt?.toIso8601String(),
  'modifiedAt': instance.modifiedAt?.toIso8601String(),
  'isEdited': instance.isEdited,
  'userName': instance.userName,
};
