import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'actor.dart';
import 'genre.dart';

part 'movie.g.dart';

class ByteArrayConverter implements JsonConverter<String?, dynamic> {
  const ByteArrayConverter();

  @override
  String? fromJson(dynamic json) {
    print('ByteArrayConverter.fromJson called with: $json (type: ${json.runtimeType})');
    if (json == null) return null;
    if (json is String) {
      print('Image is already a string, length: ${json.length}');
      return json;
    }
    if (json is List<int>) {
      print('Image is a List<int>, length: ${json.length}');
      final result = base64Encode(Uint8List.fromList(json));
      print('Converted to base64 string, length: ${result.length}');
      return result;
    }
    print('Unknown image type: ${json.runtimeType}');
    return null;
  }

  @override
  dynamic toJson(String? object) {
    if (object == null) return null;
    try {
      return base64Decode(object);
    } catch (e) {
      return object;
    }
  }
}

@JsonSerializable()
class Movie {
  int? id;
  String? title;
  String? description;
  int? durationMinutes;
  String? director;
  DateTime? releaseDate;
  int? releaseYear;
  List<Genre>? genres;
  @ByteArrayConverter()
  String? image;
  String? trailerUrl;
  double? grade;
  bool? isComingSoon;
  List<Actor>? actors;
  final bool isDeleted;

  Movie({
    this.id,
    this.title,
    this.description,
    this.durationMinutes,
    this.director,
    this.releaseDate,
    this.releaseYear,
    this.genres,
    this.image,
    this.trailerUrl,
    this.grade,
    this.isComingSoon,
    this.actors,
    required this.isDeleted,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
} 