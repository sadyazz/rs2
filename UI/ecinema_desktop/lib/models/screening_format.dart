import 'package:json_annotation/json_annotation.dart';

part 'screening_format.g.dart';

@JsonSerializable()
class ScreeningFormat {
  int? id;
  String? name;
  String? description;
  double? priceMultiplier;
  bool? isDeleted;

  ScreeningFormat({
    this.id,
    this.name,
    this.description,
    this.priceMultiplier,
    this.isDeleted,
  });

  factory ScreeningFormat.fromJson(Map<String, dynamic> json) => _$ScreeningFormatFromJson(json);
  Map<String, dynamic> toJson() => _$ScreeningFormatToJson(this);
} 