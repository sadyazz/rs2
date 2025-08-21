import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

@JsonSerializable()
class Seat {
  final int? id;
  final String? name;
  final int hallId;
  final String row;
  final int number;

  const Seat({
    this.id,
    this.name,
    required this.hallId,
    required this.row,
    required this.number,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);

  Seat copyWith({
    int? id,
    String? name,
    int? hallId,
    String? row,
    int? number,
  }) {
    return Seat(
      id: id ?? this.id,
      name: name ?? this.name,
      hallId: hallId ?? this.hallId,
      row: row ?? this.row,
      number: number ?? this.number,
    );
  }
}
