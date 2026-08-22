class IndustryEntity {
  final String? id;
  final String name;
  final String color;

  IndustryEntity({this.id, required this.name, required this.color});

  factory IndustryEntity.fromJson(Map<String, dynamic> json) {
    return IndustryEntity(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "color": color};
  }
}
