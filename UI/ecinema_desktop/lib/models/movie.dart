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
  List<Actor>? actors;
  final bool isDeleted;
  final bool? isComingSoon;

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
    this.actors,
    required this.isDeleted,
    this.isComingSoon,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}