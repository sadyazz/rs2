class Hall {
  int? id;
  String? name;
  int? capacity;
  bool? isActive;
  bool? isDeleted;

  Hall({
    this.id,
    this.name,
    this.capacity,
    this.isActive,
    this.isDeleted,
  });

  Hall.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    capacity = json['capacity'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['capacity'] = capacity;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    return data;
  }
} 