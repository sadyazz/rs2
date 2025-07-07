import 'package:json_annotation/json_annotation.dart';

part 'screening.g.dart';

@JsonSerializable()
class Screening {
  int? id;
  DateTime? startTime;
  DateTime? endTime;
  double? basePrice;
  String? language;
  bool? hasSubtitles;
  bool? isActive;
  bool? isDeleted;
  int? movieId;
  String? movieTitle;
  String? movieImage;
  int? hallId;
  String? hallName;
  int? screeningFormatId;
  String? screeningFormatName;
  double? screeningFormatPriceMultiplier;
  int? reservationsCount;
  int? availableSeats;

  Screening({
    this.id,
    this.startTime,
    this.endTime,
    this.basePrice,
    this.language,
    this.hasSubtitles,
    this.isActive,
    this.isDeleted,
    this.movieId,
    this.movieTitle,
    this.movieImage,
    this.hallId,
    this.hallName,
    this.screeningFormatId,
    this.screeningFormatName,
    this.screeningFormatPriceMultiplier,
    this.reservationsCount,
    this.availableSeats,
  });

  factory Screening.fromJson(Map<String, dynamic> json) => _$ScreeningFromJson(json);
  Map<String, dynamic> toJson() => _$ScreeningToJson(this);
} 