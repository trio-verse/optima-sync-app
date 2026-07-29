import 'package:equatable/equatable.dart';

abstract class CreateOrgEvent extends Equatable {
  const CreateOrgEvent();

  @override
  List<Object> get props => [];
}

class PickImageEvent extends CreateOrgEvent {}

class CreateOrgSubmitted extends CreateOrgEvent {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String description;

  const CreateOrgSubmitted({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.description,
  });

  @override
  List<Object> get props => [name, email, phone, address, description];
}
