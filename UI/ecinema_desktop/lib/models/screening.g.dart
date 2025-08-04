// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screening.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Screening _$ScreeningFromJson(Map<String, dynamic> json) => Screening(
      id: (json['id'] as num?)?.toInt(),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      basePrice: (json['basePrice'] as num?)?.toDouble(),
      language: json['language'] as String?,
      hasSubtitles: json['hasSubtitles'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      movieId: (json['movieId'] as num?)?.toInt(),
      movieTitle: json['movieTitle'] as String?,
      movieImage: json['movieImage'] as String?,
      hallId: (json['hallId'] as num?)?.toInt(),
      hallName: json['hallName'] as String?,
      screeningFormatId: (json['screeningFormatId'] as num?)?.toInt(),
      screeningFormatName: json['screeningFormatName'] as String?,
      screeningFormatPriceMultiplier:
          (json['screeningFormatPriceMultiplier'] as num?)?.toDouble(),
      reservationsCount: (json['reservationsCount'] as num?)?.toInt(),
      availableSeats: (json['availableSeats'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScreeningToJson(Screening instance) => <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'basePrice': instance.basePrice,
      'language': instance.language,
      'hasSubtitles': instance.hasSubtitles,
      'isDeleted': instance.isDeleted,
      'movieId': instance.movieId,
      'movieTitle': instance.movieTitle,
      'movieImage': instance.movieImage,
      'hallId': instance.hallId,
      'hallName': instance.hallName,
      'screeningFormatId': instance.screeningFormatId,
      'screeningFormatName': instance.screeningFormatName,
      'screeningFormatPriceMultiplier': instance.screeningFormatPriceMultiplier,
      'reservationsCount': instance.reservationsCount,
      'availableSeats': instance.availableSeats,
    };
