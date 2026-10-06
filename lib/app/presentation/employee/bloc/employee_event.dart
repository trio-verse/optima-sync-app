import 'package:equatable/equatable.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeeEvent {
  const LoadEmployees();
}

class CreateEmployeeSubmitted extends EmployeeEvent {
  final EmployeeInput input;
  const CreateEmployeeSubmitted(this.input);

  @override
  List<Object?> get props => [input];
}

class UpdateEmployeeSubmitted extends EmployeeEvent {
  final String employeeId;
  final EmployeeInput input;
  const UpdateEmployeeSubmitted(this.employeeId, this.input);

  @override
  List<Object?> get props => [employeeId, input];
}

class DeleteEmployeeSubmitted extends EmployeeEvent {
  final String employeeId;
  const DeleteEmployeeSubmitted(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}
