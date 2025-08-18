class Role {
  final int? id;
  final String? name;
  final String? description;
  final bool? isActive;

  const Role({
    this.id,
    this.name,
    this.description,
    this.isActive,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
    };
  }
}
