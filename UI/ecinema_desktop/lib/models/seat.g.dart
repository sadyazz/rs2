// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      id: (json['id'] as num?)?.toInt(),
      hallId: (json['hallId'] as num).toInt(),
      rowNumber: (json['rowNumber'] as num).toInt(),
      seatNumber: (json['seatNumber'] as num).toInt(),
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'id': instance.id,
      'hallId': instance.hallId,
      'rowNumber': instance.rowNumber,
      'seatNumber': instance.seatNumber,
    };
