// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['description'] as String?,
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
  director: json['director'] as String?,
  releaseDate:
      json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
  releaseYear: (json['releaseYear'] as num?)?.toInt(),
  genres:
      (json['genres'] as List<dynamic>?)
          ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
  image: const ByteArrayConverter().fromJson(json['image']),
  trailerUrl: json['trailerUrl'] as String?,
  grade: (json['grade'] as num?)?.toDouble(),
  isComingSoon: json['isComingSoon'] as bool?,
  actors:
      (json['actors'] as List<dynamic>?)
          ?.map((e) => Actor.fromJson(e as Map<String, dynamic>))
          .toList(),
  isDeleted: json['isDeleted'] as bool,
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'durationMinutes': instance.durationMinutes,
  'director': instance.director,
  'releaseDate': instance.releaseDate?.toIso8601String(),
  'releaseYear': instance.releaseYear,
  'genres': instance.genres,
  'image': const ByteArrayConverter().toJson(instance.image),
  'trailerUrl': instance.trailerUrl,
  'grade': instance.grade,
  'isComingSoon': instance.isComingSoon,
  'actors': instance.actors,
  'isDeleted': instance.isDeleted,
};
