// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  provider: json['provider'] as String?,
  transactionId: json['transactionId'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  dateTime:
      json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'provider': instance.provider,
  'transactionId': instance.transactionId,
  'amount': instance.amount,
  'dateTime': instance.dateTime?.toIso8601String(),
};
