// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hall _$HallFromJson(Map<String, dynamic> json) => Hall(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      location: json['location'] as String?,
      screenType: json['screenType'] as String?,
      soundSystem: json['soundSystem'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
    );

Map<String, dynamic> _$HallToJson(Hall instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'screenType': instance.screenType,
      'soundSystem': instance.soundSystem,
      'capacity': instance.capacity,
      'isDeleted': instance.isDeleted,
    };
