import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

@JsonSerializable()
class Seat {
  final int? id;
  final int hallId;
  final int rowNumber;
  final int seatNumber;
  final bool isActive;

  const Seat({
    this.id,
    required this.hallId,
    required this.rowNumber,
    required this.seatNumber,
    this.isActive = true,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);

  Seat copyWith({
    int? id,
    int? hallId,
    int? rowNumber,
    int? seatNumber,
    bool? isActive,
  }) {
    return Seat(
      id: id ?? this.id,
      hallId: hallId ?? this.hallId,
      rowNumber: rowNumber ?? this.rowNumber,
      seatNumber: seatNumber ?? this.seatNumber,
      isActive: isActive ?? this.isActive,
    );
  }
}
