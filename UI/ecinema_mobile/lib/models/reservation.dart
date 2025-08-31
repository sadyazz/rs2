import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'dart:typed_data';

part 'reservation.g.dart';

class ByteArrayConverter implements JsonConverter<String?, dynamic> {
  const ByteArrayConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) {
      return json;
    }
    if (json is List<int>) {
      final result = base64Encode(Uint8List.fromList(json));
      return result;
    }
    return null;
  }

  @override
  dynamic toJson(String? object) {
    if (object == null) return null;
    try {
      return base64Decode(object);
    } catch (e) {
      return object;
    }
  }
}

class SeatIdsConverter implements JsonConverter<List<int>, dynamic> {
  const SeatIdsConverter();

  @override
  List<int> fromJson(dynamic json) {
    if (json == null) return [];
    
    if (json is List) {
      return List<int>.from(json);
    } else if (json is String) {
      try {
        if (json.isNotEmpty) {
          return json.split(',').map((s) => int.tryParse(s.trim()) ?? 0).where((i) => i > 0).toList();
        }
      } catch (e) {
        print('Warning: Could not parse seatIds string: $json');
      }
    }
    return [];
  }

  @override
  dynamic toJson(List<int> object) {
    return object;
  }
}

@JsonSerializable()
class Reservation {
  final int id;
  final DateTime reservationTime;
  final double totalPrice;
  final double originalPrice;
  final double? discountPercentage;
  final bool isDeleted;
  final int userId;
  final String userName;
  final int screeningId;
  final String movieTitle;
  final DateTime screeningStartTime;
  @SeatIdsConverter()
  final List<int> seatIds;
  final int numberOfTickets;
  final int? promotionId;
  final String? promotionName;
  final int? paymentId;
  final String? paymentStatus;
  @JsonKey(name: 'state')
  final String reservationState;
  @ByteArrayConverter()
  final String? movieImage;
  final String? hallName;
  @JsonKey(name: 'qrcodeBase64')
  final String? qrcodeBase64;
  final List<String>? seatNames;

  Reservation({
    required this.id,
    required this.reservationTime,
    required this.totalPrice,
    required this.originalPrice,
    this.discountPercentage,
    required this.isDeleted,
    required this.userId,
    required this.userName,
    required this.screeningId,
    required this.movieTitle,
    required this.screeningStartTime,
    required this.seatIds,
    required this.numberOfTickets,
    this.promotionId,
    this.promotionName,
    this.paymentId,
    this.paymentStatus,
    required this.reservationState,
    this.movieImage,
    this.hallName,
    this.qrcodeBase64,
    this.seatNames,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
