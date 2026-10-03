class EmployeeEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String position;
  final double costPerHour;
  final int hoursPerPoint;
  final DateTime? createdAt;

  const EmployeeEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.costPerHour,
    required this.hoursPerPoint,
    this.createdAt,
  });

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) {
    return EmployeeEntity(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      email: '${json['email'] ?? ''}',
      phone: '${json['phone'] ?? ''}',
      position: '${json['position'] ?? ''}',
      costPerHour: double.tryParse('${json['cost_per_hour'] ?? 0}') ?? 0,
      hoursPerPoint:
          int.tryParse(
            '${json['houres_per_point'] ?? json['hours_per_point'] ?? 1}',
          ) ??
          1,
      createdAt: DateTime.tryParse('${json['created_at'] ?? ''}'),
    );
  }
}

class EmployeeInput {
  final String name;
  final String email;
  final String phone;
  final String position;
  final double costPerHour;
  final int hoursPerPoint;

  const EmployeeInput({
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.costPerHour,
    required this.hoursPerPoint,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'position': position,
      'cost_per_hour': costPerHour,
      'houres_per_point': hoursPerPoint,
    };
  }
}
