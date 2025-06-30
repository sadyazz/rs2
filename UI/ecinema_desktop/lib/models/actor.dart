import 'package:json_annotation/json_annotation.dart';

part 'actor.g.dart';

@JsonSerializable()
class Actor {
  int? id;
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? biography;
  String? image;
  bool? isActive;

  Actor({
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.biography,
    this.image,
    this.isActive,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
  Map<String, dynamic> toJson() => _$ActorToJson(this);
} 