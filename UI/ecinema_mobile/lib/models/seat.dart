import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

@JsonSerializable()
class Seat {
  final int id;
  final int hallId;
  final String? name;
  final bool? isReserved;

  const Seat({
    required this.id,
    required this.hallId,
    this.name,
    this.isReserved,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);

  Seat copyWith({
    int? id,
    int? hallId,
    String? name,
    bool? isReserved,
  }) {
    return Seat(
      id: id ?? this.id,
      hallId: hallId ?? this.hallId,
      name: name ?? this.name,
      isReserved: isReserved ?? this.isReserved,
    );
  }
}
