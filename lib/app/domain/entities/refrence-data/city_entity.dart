class CityEntity {
  final String? id;
  final String name;
  final String color;

  CityEntity({this.id, required this.name, required this.color});

  factory CityEntity.fromJson(Map<String, dynamic> json) {
    return CityEntity(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "color": color};
  }
}
