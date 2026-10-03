import 'package:dartz/dartz.dart';
import 'package:optima_sync_v2/app/domain/entities/employee_entity.dart';
import 'package:optima_sync_v2/core/errors/failures.dart';

abstract class EmployeeRepository {
  Future<Either<WhateverFailure, List<EmployeeEntity>>> getEmployees();
  Future<Either<WhateverFailure, EmployeeEntity>> createEmployee(
    EmployeeInput input,
  );
  Future<Either<WhateverFailure, EmployeeEntity>> updateEmployee(
    String employeeId,
    EmployeeInput input,
  );
  Future<Either<WhateverFailure, void>> deleteEmployee(String employeeId);
}
