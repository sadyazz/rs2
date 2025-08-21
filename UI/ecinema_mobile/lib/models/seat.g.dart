// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  hallId: (json['hallId'] as num).toInt(),
  row: json['row'] as String,
  number: (json['number'] as num).toInt(),
);

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'hallId': instance.hallId,
  'row': instance.row,
  'number': instance.number,
};
