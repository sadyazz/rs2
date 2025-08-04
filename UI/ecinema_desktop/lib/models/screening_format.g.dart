// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screening_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScreeningFormat _$ScreeningFormatFromJson(Map<String, dynamic> json) =>
    ScreeningFormat(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      priceMultiplier: (json['priceMultiplier'] as num?)?.toDouble(),
      isDeleted: json['isDeleted'] as bool?,
    );

Map<String, dynamic> _$ScreeningFormatToJson(ScreeningFormat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'priceMultiplier': instance.priceMultiplier,
      'isDeleted': instance.isDeleted,
    };
