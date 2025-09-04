import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  int? id;
  int? userId;
  String? provider;
  String? transactionId;
  double? amount;
  DateTime? dateTime;

  Payment({
    this.id,
    this.userId,
    this.provider,
    this.transactionId,
    this.amount,
    this.dateTime,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
