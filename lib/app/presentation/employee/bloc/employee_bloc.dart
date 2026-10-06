import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/app/domain/usecases/employee_usecases.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeUsecases usecases;

  EmployeeBloc({required this.usecases}) : super(EmployeeInitial()) {
    on<LoadEmployees>(_load);
    on<CreateEmployeeSubmitted>(_create);
    on<UpdateEmployeeSubmitted>(_update);
    on<DeleteEmployeeSubmitted>(_delete);
  }

  List<EmployeeEntity> get _currentEmployees => switch (state) {
    EmployeeLoaded(:final employees) => employees,
    EmployeeWorking(:final employees) => employees,
    EmployeeFailure(:final employees) => employees,
    _ => const [],
  };

  String _message(WhateverFailure failure) {
    return failure.when(
      serverError: () => 'The employee request failed. Please try again.',
      whatoffline: () => 'No internet connection.',
      database: () => 'Unable to update the local data.',
    );
  }

  Future<void> _load(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    final result = await usecases.getEmployees();
    result.fold(
      (failure) => emit(EmployeeFailure(_message(failure))),
      (employees) => emit(EmployeeLoaded(employees)),
    );
  }

  Future<void> _create(
    CreateEmployeeSubmitted event,
    Emitter<EmployeeState> emit,
  ) async {
    final current = _currentEmployees;
    emit(EmployeeWorking(current));
    final result = await usecases.createEmployee(event.input);
    result.fold(
      (failure) => emit(EmployeeFailure(_message(failure), employees: current)),
      (employee) => emit(
        EmployeeLoaded(
          [employee, ...current],
          message: 'Employee added successfully.',
        ),
      ),
    );
  }

  Future<void> _update(
    UpdateEmployeeSubmitted event,
    Emitter<EmployeeState> emit,
  ) async {
    final current = _currentEmployees;
    emit(EmployeeWorking(current));
    final result = await usecases.updateEmployee(event.employeeId, event.input);
    result.fold(
      (failure) => emit(EmployeeFailure(_message(failure), employees: current)),
      (employee) => emit(
        EmployeeLoaded(
          current
              .map((item) => item.id == employee.id ? employee : item)
              .toList(),
          message: 'Employee updated successfully.',
        ),
      ),
    );
  }

  Future<void> _delete(
    DeleteEmployeeSubmitted event,
    Emitter<EmployeeState> emit,
  ) async {
    final current = _currentEmployees;
    emit(EmployeeWorking(current));
    final result = await usecases.deleteEmployee(event.employeeId);
    result.fold(
      (failure) => emit(EmployeeFailure(_message(failure), employees: current)),
      (_) => emit(
        EmployeeLoaded(
          current.where((item) => item.id != event.employeeId).toList(),
          message: 'Employee removed successfully.',
        ),
      ),
    );
  }
}
