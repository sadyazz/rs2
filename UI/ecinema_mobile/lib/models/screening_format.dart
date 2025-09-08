class ScreeningFormat {
  int? id;
  String? name;
  String? description;
  double? priceMultiplier;
  bool? isDeleted;

  ScreeningFormat({
    this.id,
    this.name,
    this.description,
    this.priceMultiplier,
    this.isDeleted,
  });

  ScreeningFormat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    priceMultiplier = json['priceMultiplier']?.toDouble();
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['priceMultiplier'] = priceMultiplier;
    data['isDeleted'] = isDeleted;
    return data;
  }
} 
