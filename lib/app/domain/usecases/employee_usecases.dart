import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/app/domain/repo/employee/employee_repo.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

class EmployeeUsecases {
  final EmployeeRepository repo;

  EmployeeUsecases({required this.repo});

  Future<Either<WhateverFailure, List<EmployeeEntity>>> getEmployees() =>
      repo.getEmployees();

  Future<Either<WhateverFailure, EmployeeEntity>> createEmployee(
    EmployeeInput input,
  ) => repo.createEmployee(input);

  Future<Either<WhateverFailure, EmployeeEntity>> updateEmployee(
    String employeeId,
    EmployeeInput input,
  ) => repo.updateEmployee(employeeId, input);

  Future<Either<WhateverFailure, void>> deleteEmployee(String employeeId) =>
      repo.deleteEmployee(employeeId);
}
