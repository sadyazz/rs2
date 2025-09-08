class Promotion {
  final int id;
  final String name;
  final String description;
  final String? code;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final bool isDeleted;

  Promotion({
    required this.id,
    required this.name,
    required this.description,
    this.code,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.isDeleted,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      code: json['code'],
      discountPercentage: double.parse(json['discountPercentage'].toString()),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'discountPercentage': discountPercentage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}
