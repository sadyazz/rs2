// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Actor _$ActorFromJson(Map<String, dynamic> json) => Actor(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      biography: json['biography'] as String?,
      image: json['image'] as String?,
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool,
    );

Map<String, dynamic> _$ActorToJson(Actor instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'biography': instance.biography,
      'image': instance.image,
      'isActive': instance.isActive,
      'isDeleted': instance.isDeleted,
    };
