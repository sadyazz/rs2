import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

@JsonSerializable()
class Seat {
  final int id;
  final String? name;
  final bool? isReserved;

  const Seat({
    required this.id,
    this.name,
    this.isReserved,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);

  Seat copyWith({
    int? id,
    String? name,
    bool? isReserved,
  }) {
    return Seat(
      id: id ?? this.id,
      name: name ?? this.name,
      isReserved: isReserved ?? this.isReserved,
    );
  }
}
