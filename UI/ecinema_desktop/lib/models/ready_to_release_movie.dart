import 'package:json_annotation/json_annotation.dart';

part 'ready_to_release_movie.g.dart';

@JsonSerializable()
class ReadyToReleaseMovie {
  final int id;
  final String title;
  @JsonKey(name: 'releaseDate')
  final DateTime releaseDate;

  const ReadyToReleaseMovie({
    required this.id,
    required this.title,
    required this.releaseDate,
  });

  factory ReadyToReleaseMovie.fromJson(Map<String, dynamic> json) =>
      _$ReadyToReleaseMovieFromJson(json);

  Map<String, dynamic> toJson() => _$ReadyToReleaseMovieToJson(this);
}
