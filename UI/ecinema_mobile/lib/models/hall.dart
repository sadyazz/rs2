class Hall {
  int? id;
  String? name;
  String? location;
  String? screenType;
  String? soundSystem;
  int? capacity;
  bool? isDeleted;

  Hall({
    this.id,
    this.name,
    this.location,
    this.screenType,
    this.soundSystem,
    this.capacity,
    this.isDeleted,
  });

  Hall.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    screenType = json['screenType'];
    soundSystem = json['soundSystem'];
    capacity = json['capacity'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['location'] = location;
    data['screenType'] = screenType;
    data['soundSystem'] = soundSystem;
    data['capacity'] = capacity;
    data['isDeleted'] = isDeleted;
    return data;
  }
} 
