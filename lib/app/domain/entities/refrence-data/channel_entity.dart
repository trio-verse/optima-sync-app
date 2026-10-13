class ChannelEntity {
  final String? id;
  final String name;
  final String color;

  ChannelEntity({this.id, required this.name, required this.color});

  factory ChannelEntity.fromJson(Map<String, dynamic> json) {
    return ChannelEntity(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "color": color};
  }
}
