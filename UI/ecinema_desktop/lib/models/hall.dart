import 'package:json_annotation/json_annotation.dart';

part 'hall.g.dart';

@JsonSerializable()
class Hall {
  int? id;
  String? name;
  String? location;
  String? screenType;
  String? soundSystem;
  int? capacity;
  bool? isDeleted;

  Hall({
    this.id,
    this.name,
    this.location,
    this.screenType,
    this.soundSystem,
    this.capacity,
    this.isDeleted,
  });

  factory Hall.fromJson(Map<String, dynamic> json) => _$HallFromJson(json);
  Map<String, dynamic> toJson() => _$HallToJson(this);
} 