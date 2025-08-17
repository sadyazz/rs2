// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready_to_release_movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadyToReleaseMovie _$ReadyToReleaseMovieFromJson(Map<String, dynamic> json) =>
    ReadyToReleaseMovie(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
    );

Map<String, dynamic> _$ReadyToReleaseMovieToJson(
        ReadyToReleaseMovie instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'releaseDate': instance.releaseDate.toIso8601String(),
    };
