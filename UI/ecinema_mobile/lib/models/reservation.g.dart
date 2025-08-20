// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
  id: (json['id'] as num).toInt(),
  reservationTime: DateTime.parse(json['reservationTime'] as String),
  totalPrice: (json['totalPrice'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num).toDouble(),
  discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
  status: json['status'] as String,
  isDeleted: json['isDeleted'] as bool,
  userId: (json['userId'] as num).toInt(),
  userName: json['userName'] as String,
  screeningId: (json['screeningId'] as num).toInt(),
  movieTitle: json['movieTitle'] as String,
  screeningStartTime: DateTime.parse(json['screeningStartTime'] as String),
  seatIds: const SeatIdsConverter().fromJson(json['seatIds']),
  numberOfTickets: (json['numberOfTickets'] as num).toInt(),
  promotionId: (json['promotionId'] as num?)?.toInt(),
  promotionName: json['promotionName'] as String?,
  paymentId: (json['paymentId'] as num?)?.toInt(),
  paymentStatus: json['paymentStatus'] as String?,
  reservationState: json['reservationState'] as String,
  movieImage: const ByteArrayConverter().fromJson(json['movieImage']),
  hallName: json['hallName'] as String,
);

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reservationTime': instance.reservationTime.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'originalPrice': instance.originalPrice,
      'discountPercentage': instance.discountPercentage,
      'status': instance.status,
      'isDeleted': instance.isDeleted,
      'userId': instance.userId,
      'userName': instance.userName,
      'screeningId': instance.screeningId,
      'movieTitle': instance.movieTitle,
      'screeningStartTime': instance.screeningStartTime.toIso8601String(),
      'seatIds': const SeatIdsConverter().toJson(instance.seatIds),
      'numberOfTickets': instance.numberOfTickets,
      'promotionId': instance.promotionId,
      'promotionName': instance.promotionName,
      'paymentId': instance.paymentId,
      'paymentStatus': instance.paymentStatus,
      'reservationState': instance.reservationState,
      'movieImage': const ByteArrayConverter().toJson(instance.movieImage),
      'hallName': instance.hallName,
    };
