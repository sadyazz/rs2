import 'package:json_annotation/json_annotation.dart';

part 'promotion.g.dart';

@JsonSerializable()
class Promotion {
  final int? id;
  final String? name;
  final String? description;
  final String? code;
  final double? discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;
  final int? reservationCount;
  final bool? isDeleted;

  Promotion({
    this.id,
    this.name,
    this.description,
    this.code,
    this.discountPercentage,
    this.startDate,
    this.endDate,
    this.isActive,
    this.reservationCount,
    this.isDeleted,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionToJson(this);
} 