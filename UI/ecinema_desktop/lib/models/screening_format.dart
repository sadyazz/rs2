import 'package:json_annotation/json_annotation.dart';

part 'screening_format.g.dart';

@JsonSerializable()
class ScreeningFormat {
  int? id;
  String? name;
  double? priceMultiplier;
  bool? isActive;
  bool? isDeleted;

  ScreeningFormat({
    this.id,
    this.name,
    this.priceMultiplier,
    this.isActive,
    this.isDeleted,
  });

  factory ScreeningFormat.fromJson(Map<String, dynamic> json) => _$ScreeningFormatFromJson(json);
  Map<String, dynamic> toJson() => _$ScreeningFormatToJson(this);
} 