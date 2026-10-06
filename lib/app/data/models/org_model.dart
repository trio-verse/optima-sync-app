import 'package:json_annotation/json_annotation.dart';

part 'org_model.g.dart';

@JsonSerializable()
class OrgModel {
  final String? id;
  // @JsonKey(name: 'Organization_Name')
  final String name;
  final String email;
  final String phone;
  final String address;
  final String description;

  OrgModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.description,
  });

  factory OrgModel.fromJson(Map<String, dynamic> json) =>
      _$OrgModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrgModelToJson(this);
}
