import 'package:json_annotation/json_annotation.dart';

part 'actor.g.dart';

@JsonSerializable()
class Actor {
  int? id;
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  final String? biography;
  String? image;
  final bool isDeleted;

  Actor({
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.biography,
    this.image,
    required this.isDeleted,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
  Map<String, dynamic> toJson() => _$ActorToJson(this);
} 
