import 'package:json_annotation/json_annotation.dart';
import 'actor.dart';
import 'genre.dart';

part 'movie.g.dart';

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
  String? image;
  String? trailerUrl;
  double? grade;
  bool? isActive;
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
    this.isActive,
    this.actors,
    required this.isDeleted,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
} 