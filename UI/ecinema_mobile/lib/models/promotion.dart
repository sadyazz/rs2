class Promotion {
  final int? id;
  final String? name;
  final String? description;
  final String? code;
  final double? discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? reservationCount;
  final bool? isDeleted;

  Promotion({
    this.id,
    this.name,
    this.description,
    this.code,
    this.discountPercentage,
    this.startDate,
    this.endDate,
    this.reservationCount,
    this.isDeleted,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      code: json['code'],
      discountPercentage: json['discountPercentage']?.toDouble(),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      reservationCount: json['reservationCount'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'discountPercentage': discountPercentage,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'reservationCount': reservationCount,
      'isDeleted': isDeleted,
    };
  }
} 