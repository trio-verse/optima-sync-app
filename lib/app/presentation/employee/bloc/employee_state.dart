import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeeEntity> employees;
  final String? message;

  const EmployeeLoaded(this.employees, {this.message});

  @override
  List<Object?> get props => [employees, message];
}

class EmployeeWorking extends EmployeeState {
  final List<EmployeeEntity> employees;
  const EmployeeWorking(this.employees);

  @override
  List<Object?> get props => [employees];
}

class EmployeeFailure extends EmployeeState {
  final String message;
  final List<EmployeeEntity> employees;

  const EmployeeFailure(this.message, {this.employees = const []});

  @override
  List<Object?> get props => [message, employees];
}
