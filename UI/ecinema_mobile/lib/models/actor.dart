import 'package:json_annotation/json_annotation.dart';

part 'actor.g.dart';

@JsonSerializable()
class Actor {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? biography;
  final DateTime? dateOfBirth;
  final bool isDeleted;

  Actor({
    required this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.biography,
    this.dateOfBirth,
    required this.isDeleted,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
  Map<String, dynamic> toJson() => _$ActorToJson(this);
} 