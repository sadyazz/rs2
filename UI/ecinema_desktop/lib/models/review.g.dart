// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: (json['id'] as num?)?.toInt(),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool,
      isSpoiler: json['isSpoiler'] as bool,
      isEdited: json['isEdited'] as bool?,
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      movieId: (json['movieId'] as num).toInt(),
      movieTitle: json['movieTitle'] as String,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt?.toIso8601String(),
      'isActive': instance.isActive,
      'isDeleted': instance.isDeleted,
      'isSpoiler': instance.isSpoiler,
      'isEdited': instance.isEdited,
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'movieId': instance.movieId,
      'movieTitle': instance.movieTitle,
    };
