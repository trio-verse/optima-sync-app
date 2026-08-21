class ProductEntity {
  final String? id;
  final String name;
  final double price;
  final String description;

  ProductEntity({
    this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      price: double.tryParse('${json['price'] ?? 0}') ?? 0,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "price": price, "description": description};
  }
}
