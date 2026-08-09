class OrgEntity {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String description;
  final String? logo;

  const OrgEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.description,
    this.logo,
  });
  // Converter
  factory OrgEntity.fromJson(Map<String, dynamic> json) => OrgEntity(
    id: json['id'].toString(),
    name: json['name'],
    email: json['email'],
    phone: json['phone_number'],
    address: json['address'],
    description: json['description'],
    logo: json['logo'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "description": description,
    "logo": logo,
  };
}
